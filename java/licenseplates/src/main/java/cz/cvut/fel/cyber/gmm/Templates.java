package cz.cvut.fel.cyber.gmm;

import au.com.bytecode.opencsv.CSVWriter;

import java.io.FileWriter;
import java.io.IOException;
import java.util.Map;
import java.util.SortedMap;
import java.util.TreeMap;

/**
 * Created by IntelliJ IDEA.
 * User: draid
 * Date: 22.11.11
 * Time: 15:03
 * To change this template use File | Settings | File Templates.
 */
public class Templates {

    private SortedMap<ImageColumnKey, double[]> data;

    public Templates() {
        data = new TreeMap<ImageColumnKey, double[]>();
    }

    public void addTemplate(ImageColumnKey key, double[] dataValues) {
        data.put(key, dataValues);
    }

    public void printToFile(String fileName) throws IOException {
        CSVWriter writer = new CSVWriter(new FileWriter(fileName));

        for (Map.Entry<ImageColumnKey, double[]> e : data.entrySet()) {
            String[] line = new String[e.getValue().length + 1];

            line[0] = e.getKey().toString();
            double[] data = e.getValue();
            for (int i = 1; i < line.length; i++) {
                line[i] = String.valueOf(data[i - 1]);
            }

            writer.writeNext(line);
        }

        writer.close();

    }

}
