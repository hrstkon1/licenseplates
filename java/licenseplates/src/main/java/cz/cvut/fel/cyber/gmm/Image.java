package cz.cvut.fel.cyber.gmm;

import au.com.bytecode.opencsv.CSVReader;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by IntelliJ IDEA.
 * User: draid
 * Date: 22.11.11
 * Time: 14:39
 * To change this template use File | Settings | File Templates.
 */
public class Image {

    private final List<AnnotatedImageColumn> data;

    private static int maxZero = 0;

    public static Image loadImage(File file) throws IOException {
        CSVReader reader = new CSVReader(new FileReader(file), '\t');

        List<String[]> data = reader.readAll();

        List<AnnotatedImageColumn> imageData = new ArrayList<AnnotatedImageColumn>();

        String lastKey = null;
        int order = 0;
        AnnotatedImageColumn column = null;
        for (String[] line : data) {
            if (line[0].equals(lastKey)) {
                order++;
            } else {
                order = 0;
            }

            if (line[0].equals("&")) {
                if (column != null) {
                    column.setLast(true);
                }
                continue;
            }
            lastKey = line[0];
            ImageColumnKey key = new ImageColumnKey(line[0], order);

            double[] columnValues = new double[line.length-1];

            for (int i = 1; i < line.length; i++) {
                columnValues[i-1] = Double.parseDouble(line[i]);
            }

            column = new AnnotatedImageColumn(key, new ImageColumn(columnValues));
            imageData.add(column);
        }
        reader.close();
        return new Image(imageData);
    }

    public Image(List<AnnotatedImageColumn> data) {

        this.data = data;
    }

    public List<AnnotatedImageColumn> getData() {
        return data;
    }
}
