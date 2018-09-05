 
class Perceptron {
  float[] weights;
  float output;

  Perceptron(int n) {
    weights = new float[n];
    for (int i = 0; i < weights.length; i++) {
      weights[i] = random(-1, 1);
    }
  }

  void feedForward(float[] inputs) {
    float sum = 0;
    for (int i = 0; i < weights.length; i++) {
      sum += inputs[i] * weights[i];
    }
    output = sigmoid(sum);
  }

  float sigmoid(float x) {
   // return 2.0 / (1.0 + exp(-2.0 * x)) - 1.0;
    return 1.0 / (1.0 + exp(-1.0 * x));
  }
  
  void mutate() {
    weights[int(random(weights.length))] = random(-1, 1);
  }
};

class Layer {
  ArrayList<Perceptron> perceptrons;
  float[] outputs;

  Layer() {
    perceptrons = new ArrayList<Perceptron>();
  }

  void addPerceptron(Perceptron perc) {
    perceptrons.add(perc);
  }

  void run(float[] inputs) {
    outputs = new float[perceptrons.size()];
    for(int i=0; i<perceptrons.size(); i++) {
      perceptrons.get(i).feedForward(inputs);
      outputs[i] = perceptrons.get(i).output;
    }
  }
};

class Network {
  ArrayList<Layer> layers;

  Network() {
    layers = new ArrayList<Layer>();
  }

  void addLayer(Layer layer) {
    layers.add(layer);
  }

  float[] run(float[] inputs) {
    for (int i=0; i<layers.size(); i++) {
      layers.get(i).run(inputs);
      inputs = layers.get(i).outputs;
    }
    return inputs;
  }
};

class NetworkBuilder {
  int[] layerSizes;

  NetworkBuilder(int[] layerSizes) {
    this.layerSizes = layerSizes;
  }

  Network build() {
    Network network = new Network();
    int previousCount = layerSizes[0];
    for (int i=0; i<layerSizes.length; i++) {
      int inputSize = previousCount;
      network.addLayer(buildLayer(inputSize, layerSizes[i]));
      previousCount = layerSizes[i];
    }
    return network;
  }

  Layer buildLayer(int inputSize, int perceptronCount) {
    Layer layer = new Layer();
    for (int i=0; i<perceptronCount; i++) {
      Perceptron perceptron = new Perceptron(inputSize);
      layer.addPerceptron(perceptron);
    }
    return layer;
  }
};

class NetworkSerializer {
  Network network;
  
  NetworkSerializer(Network network) {
    this.network = network;
  }
  
  ArrayList<Float> collectWeights() {
    ArrayList<Float> data = new ArrayList<Float>();
    for (Layer layer : network.layers) {
      for (Perceptron perc : layer.perceptrons) {
        for (float val : perc.weights) {
          data.add(val);
        }
      }
    }
    return data;
  }
  
  void storeWeights(ArrayList<Float> data) {
    int index = 0;
    for (Layer layer : network.layers) {
      for (Perceptron perc : layer.perceptrons) {
        for (int i=0; i<perc.weights.length; i++) {
          perc.weights[i] = data.get(index);
          index++;
        }
      }
    }
  }
  
}

class NetworkVisualizer {
  void visualize(Network network) {
    for (int i=0; i<network.layers.size(); i++) {
      Layer layer = network.layers.get(i);
      println("**********", i+1, "(", layer.perceptrons.size(), ") **********");
      for (int j=0; j<network.layers.get(i).perceptrons.size(); j++) {
        Perceptron p = network.layers.get(i).perceptrons.get(j);
        println("P[", j+1, "]");
        for (int k=0; k<p.weights.length; k++) {
          print(p.weights[k], " ");
        }
        println("");
      }
    }
  }
};
