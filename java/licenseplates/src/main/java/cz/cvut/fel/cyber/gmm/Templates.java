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
        String lastName = null;
        CSVWriter writer = null;
        for (Map.Entry<ImageColumnKey, double[]> e : data.entrySet()) {
            if (e.getKey().getName().equals(lastName) == false) {
                if (writer != null) {
                    writer.flush();
                    writer.close();
                }
                writer = new CSVWriter(new FileWriter(e.getKey().getName() + ".csv"), CSVWriter.DEFAULT_SEPARATOR, CSVWriter.NO_QUOTE_CHARACTER);
                lastName = e.getKey().getName();
            }

            String[] line = new String[e.getValue().length];

            //line[0] = e.getKey().toString();
            double[] data = e.getValue();
            for (int i = 0; i < line.length; i++) {
                line[i] = String.valueOf(data[i]);
            }
            System.out.println(e.getKey().toString());
            writer.writeNext(line);
        }

        if (writer != null) {
            writer.flush();
            writer.close();
        }



    }

}
