class Path implements Comparable<Path> {
    List<PVector> nodes;
    List<Integer> order;
    
    float fitness;
    
    Path(List<PVector> nodes) {
        this.nodes = nodes;
        genOrder(nodes.size());
        calcFitness();
    }
    
    int get(int i) {
        return order.get(i);
    }
    
    int size() {
        return order.size();
    }
    
    void calcFitness() {
        float score = 0;
        for(int j=0; j<size()-1; j++) {
            score += nodes.get(get(j)).dist(nodes.get(get(j+1)));
        }
        fitness = 1/(score*score);
    }
    
    void mutate(float mutationRate) {
        for (int i = 0; i < size(); i++) {
            if (random(1) < mutationRate) {
              swap(floor(random(size())), floor(random(size())));
            }
        }
        calcFitness();
    }
    
    List<Integer> genOrder(int size) {
        order = new ArrayList<Integer>();
        for(int i=0; i<size; i++) {
            order.add(i);
        }

        // Shuffle
        for (int i = 0; i < size(); i++) {
            swap(i, floor(random(i+1)));
        }

        return order;
    }
        
    private void swap(int i, int j) {
        int temp = get(j);
        order.set(j, get(i));
        order.set(i, temp);
    }
    
    @Override
    int compareTo(Path o) {
        return Float.compare(fitness, o.fitness);
    }
}
