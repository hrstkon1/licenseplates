package cz.cvut.fel.cyber.gmm;

/**
 * Created by IntelliJ IDEA.
 * User: draid
 * Date: 22.11.11
 * Time: 14:37
 * To change this template use File | Settings | File Templates.
 */
public class AnnotatedImageColumn {

    private final ImageColumnKey key;
    private final ImageColumn data;

    public AnnotatedImageColumn(ImageColumnKey key, ImageColumn data) {
        this.key = key;
        this.data = data;
    }

    public ImageColumnKey getKey() {
        return key;
    }

    public ImageColumn getData() {
        return data;
    }


}
