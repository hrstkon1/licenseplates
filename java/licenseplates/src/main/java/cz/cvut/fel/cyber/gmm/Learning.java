package cz.cvut.fel.cyber.gmm;

import org.apache.commons.collections.primitives.ArrayIntList;
import org.apache.commons.collections.primitives.IntList;
import org.apache.commons.math.distribution.NormalDistribution;
import org.apache.commons.math.distribution.NormalDistributionImpl;
import sun.tools.tree.ArrayAccessExpression;

import java.io.IOException;
import java.lang.reflect.Array;
import java.util.*;

/**
 * Created by IntelliJ IDEA.
 * User: draid
 * Date: 22.11.11
 * Time: 14:51
 * To change this template use File | Settings | File Templates.
 */
public class Learning {

    private Map<ImageColumnKey, List<double[]>> learningData, probabilities;
    Map<String, IntList> stats = new HashMap<String, IntList>();

    public Learning() {
        learningData = new HashMap<ImageColumnKey, List<double[]>>();
        probabilities = new HashMap<ImageColumnKey, List<double[]>>();
    }

    public void addImage(Image image) {
        for (AnnotatedImageColumn column : image.getData()) {
            List<double[]> list = learningData.get(column.getKey());

            if (list == null) {
                list = new ArrayList<double[]>();
                learningData.put(column.getKey(), list);
                probabilities.put(column.getKey(), new ArrayList<double[]>());
            }

            list.add(column.getData().getData());
            probabilities.get(column.getKey()).add(new double[column.getData().getData().length]);

            if (column.isLast()) {
                if (stats.containsKey(column.getKey().getName()) == false) {
                    stats.put(column.getKey().getName(), new ArrayIntList());
                }

                stats.get(column.getKey().getName()).add(column.getKey().getOrder());
            }
        }
    }

    private NormalDistributionImpl foreground, background;

    public void learn() {
        filter();

        Map<ImageColumnKey, double[]> alphas = new HashMap<ImageColumnKey, double[]>();

        final int alphaLength = learningData.values().iterator().next().get(0).length;

        for (ImageColumnKey key : learningData.keySet()) {
            double[] alpha = new double[alphaLength];
            Arrays.fill(alpha, 0.5);
            alphas.put(key, alpha);
        }


        foreground = new NormalDistributionImpl(-1, 1);
        background = new NormalDistributionImpl(1, 1);
        System.out.printf("mean1: %f, std1: %f, mean2: %f, std2: %f\n", foreground.getMean(), foreground.getStandardDeviation(), background.getMean(), background.getStandardDeviation());

        for (int i = 0; i < 20; i++) {

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

        Templates templates = new Templates();

        for (Map.Entry<ImageColumnKey, double[]> e : alphas.entrySet()) {
            templates.addTemplate(e.getKey(), e.getValue());
        }

        try {
            templates.printToFile("alphas.csv");
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

    }

    private void filter() {




        Set<ImageColumnKey> toRemove = new HashSet<ImageColumnKey>();

        for (Map.Entry<String, IntList> e : stats.entrySet()) {
            int[] ints = e.getValue().toArray();
            Arrays.sort(ints);
            double median;
            if (ints.length == 1) {
               median = ints[0];
            }  else if (ints.length % 2 == 0) {
                int lowMiddle = (int)Math.floor(ints.length / 2.0);
                median = (ints[lowMiddle-1] + ints[lowMiddle])/2.0;

            } else {
                median = ints[ints.length / 2];
            }

            for (ImageColumnKey imageColumnKey : learningData.keySet()) {
                if (median < imageColumnKey.getOrder() && imageColumnKey.getName().equals(e.getKey())) {
                    toRemove.add(imageColumnKey);
                }
            }
            System.out.println(e.getKey() +"    "+ median);
            for (ImageColumnKey imageColumnKey : toRemove) {
                learningData.remove(imageColumnKey);
                probabilities.remove(imageColumnKey);
            }
            toRemove.clear();
        }
    }

    private void mStep(Map<ImageColumnKey, double[]> alphas) {
        double mean1 = 0,
               mean2 = 0,
               std1 = 0,
               std2 = 0,
               probSum1 = 0,
               probSum2 = 0;

        for (Map.Entry<ImageColumnKey, double[]> e : alphas.entrySet()) {
            for (int i = 0; i < e.getValue().length; i++) {
                List<double[]> columns = learningData.get(e.getKey());
                Iterator<double[]> columnIterator = columns.iterator();
                Iterator<double[]> probsIterator = probabilities.get(e.getKey()).iterator();

                double alphaUp = 0,
                       alphaDown = 0;

                while (columnIterator.hasNext()) {
                    double[] column = columnIterator.next();
                    double[] probColumn = probsIterator.next();

                    double x = column[i];
                    double prob = probColumn[i];

                    mean1 += prob * x;
                    mean2 += (1-prob) * x;

                    probSum1 += prob;
                    probSum2 += (1-prob);

                    alphaUp += prob;
                    alphaDown += (1-prob);
                }

                e.getValue()[i] = alphaUp /(alphaUp+alphaDown);
            }


        }

        mean1 = mean1 / probSum1;
        mean2 = mean2 / probSum2;

        for (Map.Entry<ImageColumnKey, double[]> e : alphas.entrySet()) {
            for (int i = 0; i < e.getValue().length; i++) {
                List<double[]> columns = learningData.get(e.getKey());
                Iterator<double[]> columnIterator = columns.iterator();
                Iterator<double[]> probsIterator = probabilities.get(e.getKey()).iterator();

                while (columnIterator.hasNext()) {
                    double[] column = columnIterator.next();
                    double[] probColumn = probsIterator.next();

                    double x = column[i];
                    double prob = probColumn[i];

                    std1 += prob * pow2(x - mean1);
                    std2 += (1-prob) * pow2(x-mean2);
                }
            }
        }

        std1 = Math.sqrt(std1 / probSum1);
        std2 = Math.sqrt(std2 / probSum2);

        foreground = new NormalDistributionImpl(mean1, std1);
        background = new NormalDistributionImpl(mean2, std2);
    }

    private void eStep(Map<ImageColumnKey, double[]> alphas) {
        for (Map.Entry<ImageColumnKey, double[]> e : alphas.entrySet()) {
            for (int i = 0; i < e.getValue().length; i++) {
                countProbability(e.getKey(), i, e.getValue()[i]);
            }
        }

        /*
        for (Map.Entry<ImageColumnKey, double[]> e : alphas.entrySet()) {
            for (int i = 0; i < e.getValue().length; i++) {
                double alpha = computeAlpha(e.getKey(), i);
                e.getValue()[i] = alpha;
            }
        }

         */
    }

    private void countProbability(ImageColumnKey key, int row, double alpha) {
        List<double[]> doubles = learningData.get(key);
        List<double[]> probs = probabilities.get(key);
        Iterator<double[]> doublesIterator = doubles.iterator();
        Iterator<double[]> probsIterator = probs.iterator();

        while (doublesIterator.hasNext()) {
            double[] column = doublesIterator.next();
            double[] probColumn = probsIterator.next();
            double tmp = alpha*foreground.density(column[row]);
            probColumn[row] = tmp/(tmp + (1-alpha)*background.density(column[row]));
        }
    }

    private double pow2(final double x) {
        return x * x;
    }
}
