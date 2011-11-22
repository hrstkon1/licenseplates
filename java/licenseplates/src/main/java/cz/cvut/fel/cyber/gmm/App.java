package cz.cvut.fel.cyber.gmm;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;

/**
 * Hello world!
 *
 */
public class App {

    public static void main(String[] args) throws FileNotFoundException, IOException {
        File folder = new File("../../matlab/output/");

        Learning l = new Learning();
        int counter = 0;
        System.out.println("Reading data");
        for (File file : folder.listFiles()) {
            l.addImage(Image.loadImage(file));
            //System.out.println(counter++);
        }
        System.out.println("Learning");
        l.learn();
    }
}
