package cz.cvut.fel.cyber.gmm;

/**
 * Created by IntelliJ IDEA.
 * User: draid
 * Date: 22.11.11
 * Time: 14:31
 * To change this template use File | Settings | File Templates.
 */
public class ImageColumn {

    private final double[] data;

    public ImageColumn(double[] data) {
        this.data = data;
    }

    public double[] getData() {
        return data;
    }
}
