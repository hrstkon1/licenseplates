package cz.cvut.fel.cyber.gmm;

/**
 * Created by IntelliJ IDEA.
 * User: draid
 * Date: 22.11.11
 * Time: 14:32
 * To change this template use File | Settings | File Templates.
 */
public class ImageColumnKey implements Comparable<ImageColumnKey> {

    public static final String SPACE_CHARACTER = "#[]";

    private final String name;
    private final int order;

    public ImageColumnKey(String name, int order) {
        this.name = name;
        if (SPACE_CHARACTER.contains(name)) {
            order = 0;
        }
        this.order = order;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        ImageColumnKey that = (ImageColumnKey) o;

        if (order != that.order) return false;
        if (name != null ? !name.equals(that.name) : that.name != null) return false;

        return true;
    }

    @Override
    public String toString() {
        return name + order;
    }

    @Override
    public int hashCode() {
        int result = name != null ? name.hashCode() : 0;
        result = 31 * result + order;
        return result;
    }

    public int compareTo(ImageColumnKey imageColumnKey) {
        int out = name.compareTo(imageColumnKey.name);

        if (out == 0) {
            out = order - imageColumnKey.order;
        }

        return out;
    }

    public String getName() {
        return name;
    }

    public int getOrder() {
        return order;
    }
}
