package cz.cvut.fel.cyber.gmm;

import org.apache.commons.math.distribution.NormalDistribution;
import org.apache.commons.math.distribution.NormalDistributionImpl;

import java.util.*;

/**
 * Created by IntelliJ IDEA.
 * User: draid
 * Date: 22.11.11
 * Time: 14:51
 * To change this template use File | Settings | File Templates.
 */
public class Learning {

    private Map<ImageColumnKey, List<double[]>> learningData;

    public Learning() {
        learningData = new HashMap<ImageColumnKey, List<double[]>>();
    }

    public void addImage(Image image) {
        for (AnnotatedImageColumn column : image.getData()) {
            List<double[]> list = learningData.get(column.getKey());

            if (list == null) {
                list = new ArrayList<double[]>();
                learningData.put(column.getKey(), list);
            }

            list.add(column.getData().getData());
        }
    }

    private NormalDistributionImpl foreground, background;

    public void learn() {
        Map<ImageColumnKey, double[]> alphas = new HashMap<ImageColumnKey, double[]>();

        for (ImageColumnKey key : learningData.keySet()) {
            alphas.put(key, new double[learningData.get(key).get(0).length]);
        }


        foreground = new NormalDistributionImpl(1, 1);
        background = new NormalDistributionImpl(-1, 1);
        System.out.printf("mean1: %f, std1: %f, mean2: %f, std2: %f\n", foreground.getMean(), foreground.getStandardDeviation(), background.getMean(), background.getStandardDeviation());

        for (int i = 0; i < 10; i++) {

            eStep(alphas);
            mStep(alphas);
            //for (Map.Entry<ImageColumnKey, double[]> e : alphas.entrySet()) {
            //    System.out.println(e.getKey() + " -> " + Arrays.toString(e.getValue()));
            //}
            System.out.printf("mean1: %f, std1: %f, mean2: %f, std2: %f\n", foreground.getMean(), foreground.getStandardDeviation(), background.getMean(), background.getStandardDeviation());

        }
        for (Map.Entry<ImageColumnKey, double[]> e : alphas.entrySet()) {
            System.out.println(e.getKey() + " -> " + Arrays.toString(e.getValue()));
        }
    }

    private void mStep(Map<ImageColumnKey, double[]> alphas) {
        double mean1 = 0,
               mean2 = 0,
               std1 = 0,
               std2 = 0,
               alphaSum1 = 0,
               alphaSum2 = 0;

        for (Map.Entry<ImageColumnKey, double[]> e : alphas.entrySet()) {
            for (int i = 0; i < e.getValue().length; i++) {
                double alpha = e.getValue()[i];
                List<double[]> columns = learningData.get(e.getKey());
                for (double[] column : columns) {
                    double x = column[i];
                    mean1 += alpha * x;
                    mean2 += (1-alpha) * x;
                    alphaSum1 += alpha;
                    alphaSum2 += (1-alpha);
                }
            }
        }

        mean1 = mean1 / alphaSum1;
        mean2 = mean2 / alphaSum2;

        for (Map.Entry<ImageColumnKey, double[]> e : alphas.entrySet()) {
            for (int i = 0; i < e.getValue().length; i++) {
                double alpha = e.getValue()[i];
                List<double[]> columns = learningData.get(e.getKey());
                for (double[] column : columns) {
                    double x = column[i];
                    std1 += alpha * pow2(x - mean1);
                    std2 += (1-alpha) * pow2(x-mean2);
                }
            }
        }

        std1 = Math.sqrt(std1 / alphaSum1);
        std2 = Math.sqrt(std2 / alphaSum2);

        foreground = new NormalDistributionImpl(mean1, std1);
        background = new NormalDistributionImpl(mean2, std2);
    }

    private void eStep(Map<ImageColumnKey, double[]> alphas) {
        for (Map.Entry<ImageColumnKey, double[]> e : alphas.entrySet()) {
            for (int i = 0; i < e.getValue().length; i++) {
                double alpha = computeAlpha(e.getKey(), i);
                e.getValue()[i] = alpha;
            }
        }
    }

    private double computeAlpha(ImageColumnKey key, int row) {
        List<double[]> doubles = learningData.get(key);
        double up = 0,
               down = 0;
        for (double[] column : doubles) {
            double tmp = foreground.density(column[row]);
            up += tmp;
            down += tmp + background.density(column[row]);
        }

        return Math.round(up / down);
    }

    private double pow2(final double x) {
        return x * x;
    }
}
