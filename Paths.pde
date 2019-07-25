class Paths {
    List<PVector> nodes;
    List<Path> population;
    int generation;
    
    int fittest;
    float maxFitness;
    float mutationRate;
    float sampleFitnessPercentileLowerBound;
    
    boolean fittestIsImmortal;
    
    Paths(List<PVector> nodes, int popSize, float mutationRate, boolean fittestIsImmortal, float sampleFitnessPercentileLowerBound) {
        this.nodes = nodes;
        this.fittestIsImmortal = fittestIsImmortal;
        this.mutationRate = mutationRate;
        this.generation=0;
        this.sampleFitnessPercentileLowerBound = sampleFitnessPercentileLowerBound;
        createPopulation(popSize);
    }
    
    Path get(int i) {
        return population.get(i);
    }
    
    int size() {
        return population.size();
    }
    
    void sort() {
        Collections.sort(population, Collections.reverseOrder());
        updateMaxFitness();
    }
    
    void createPopulation(int popSize) {
        population = new ArrayList<Path>();
        for(int i=0; i<popSize; i++) {
            population.add(new Path(nodes));
        }
        updateMaxFitness();
    }
    
    void trimPopulationTo(int popSize) {
        if(popSize<population.size()) {
            population = population.subList(0, popSize);
            updateMaxFitness();
        }
    }
    
    void increasePopulationTo(int popSize) {
        if(popSize>population.size()){
            for(int i=population.size(); i<popSize; i++) {
                population.add(new Path(nodes));
            }
            updateMaxFitness();
        }
    }
    
    void evolve() {
        generate();
        updateMaxFitness();
        generation++;
    }
    
    void updateMaxFitness() {
        maxFitness = 0;
        for (int i = 0; i < population.size(); i++) {
            float current = get(i).fitness;
            if (current > maxFitness) {
                maxFitness = current;
                fittest = i;
            }
        }
    }
    
    void generate() {
        // Refill the population with children, parents picked using sample()
        List<Path> newPop = new ArrayList<Path>();
        sort();
        for (int i = 0; i < population.size(); i++) {
            if(i==0 && fittestIsImmortal) {
                newPop.add(get(fittest));
            } else {
                Path partnerA = sample();
                Path partnerB = sample();
                Path child = crossover(partnerA, partnerB);
                child.mutate(mutationRate);
                newPop.add(child);
            }
        }
        population = newPop;
    }
    
    // monte carlo sampling method, more space efficient than previous implementation
    Path sample() {
        while(true) {
            float r = random(0, maxFitness);
            Path partner = population.get(floor(random(population.size()*sampleFitnessPercentileLowerBound)));
            if(r < partner.fitness) {
                return partner;
            }
        }
    }
    
    Path crossover(Path a, Path b) {
        // Pick a random start and endpoint
        Path c = new Path(nodes);
        c.order.clear();
        
        // Genes from a
        int start = floor(random(a.size()));
        int end = floor(random(start+1, a.size()+1));
        c.order.addAll(a.order.subList(start, end));
        
        // Genes from b
        for(int i=0; i<b.size(); i++) {
            if(!c.order.contains(b.get(i))) {
                c.order.add(b.get(i));
            }
        }
        return c;
    }
}
