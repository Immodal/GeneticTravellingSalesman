import java.util.*;

float titleSize = 50;
Button btnAdd1Gen;
Button btnAdd100Gen;
Button btnAdd1000Gen;
Button btnSort;
Button btnFittestIsImmortal;
Button btnCustomNodes;
ProblemMaker pm;

float bannerTextSize = 25;
Button btnDecMutation;
Button btnIncMutation;
float mutationStep = 0.01;
Button btnDecPopulation;
Button btnIncPopulation;
int populationStep = 50;
Button btnDecSampleFitnessLowerBound;
Button btnIncSampleFitnessLowerBound;
float sampleFitnessPercentileLowerBoundStep = 0.01;

float fullBtnW = 150;
float fullBtnH = 75;

int generations = 0;
float margin = 10;

List<PVector> problem;
Paths paths;

List<PathDrawSpace> pds;
int pdsNumRowCol = 3;


void setup() {
    size(1220, 1020);
    
    float pdsWidth = (width-(margin*3+fullBtnW))/pdsNumRowCol;
    float pdsHeight = (height-(margin*2+titleSize))/pdsNumRowCol;
    
    // Y counting from top
    btnAdd1Gen = new Button(false, "Add 1\nGeneration", 20, margin, margin+titleSize, fullBtnW, fullBtnH, 5);
    btnAdd100Gen = new Button(false, "Add 100\nGenerations", 20, margin, margin*2+titleSize+fullBtnH, fullBtnW, fullBtnH, 5);
    btnAdd1000Gen = new Button(false, "Add 1000\nGenerations", 20, margin, margin*3+titleSize+fullBtnH*2, fullBtnW, fullBtnH, 5);
    btnSort = new Button(false, "Sort", 20, margin, margin*4+titleSize+fullBtnH*3, fullBtnW, fullBtnH, 5);
    btnFittestIsImmortal = new Button(false, "Fittest is\nImmortal", 20, margin, margin*5+titleSize+fullBtnH*4, fullBtnW, fullBtnH, 5);
    btnCustomNodes = new Button(false, "Make Custom\nProblem", 20, margin, margin*6+titleSize+fullBtnH*5, fullBtnW, fullBtnH, 5);;
    
    // Y counting from bottom
    btnDecMutation = new Button(false, "Dec", 20, margin, height-margin-fullBtnH, 50, fullBtnH, 5);
    btnIncMutation = new Button(false, "Inc", 20, margin+btnDecMutation.w+50, height-margin-fullBtnH, 50, fullBtnH, 5);
    btnDecPopulation = new Button(false, "Dec", 20, margin, height-margin-fullBtnH*2-bannerTextSize, 50, fullBtnH, 5);
    btnIncPopulation = new Button(false, "Inc", 20, margin+btnDecPopulation.w+50, height-margin-fullBtnH*2-bannerTextSize, 50, fullBtnH, 5);
    btnDecSampleFitnessLowerBound = new Button(false, "Dec", 20, margin, height-margin-fullBtnH*3-bannerTextSize*2, 50, fullBtnH, 5);
    btnIncSampleFitnessLowerBound = new Button(false, "Inc", 20, margin+btnDecSampleFitnessLowerBound.w+50, height-margin-fullBtnH*3-bannerTextSize*2, 50, fullBtnH, 5);
    
    // reserved space where the paths are drawn
    pds = new ArrayList<PathDrawSpace>();
    for(int i=0; i<pdsNumRowCol; i++) {
        for(int j=0; j<pdsNumRowCol; j++) {
            pds.add(new PathDrawSpace(margin*2+fullBtnW+j*pdsWidth, margin+titleSize+i*pdsHeight, pdsWidth, pdsHeight));
        }
    }

    problem = genProblem(20);
    paths = new Paths(problem, 400, 0.1, btnFittestIsImmortal.state, 0.50);
}

void draw() {
    
    if(paths.generation<generations) {
        paths.evolve();
    }
    
    background(0);
    drawTitle();
    btnCustomNodes.draw();
    if(btnCustomNodes.state) {
        pm.draw();
    } else {
        drawPathSpaces();
        btnAdd1Gen.draw();
        btnAdd100Gen.draw();
        btnAdd1000Gen.draw();
        btnSort.draw();
        btnFittestIsImmortal.draw();
        
        btnDecMutation.draw();
        btnIncMutation.draw();
        drawMutationLabels();
        btnDecPopulation.draw();
        btnIncPopulation.draw();
        drawPopulationLabels();
        btnDecSampleFitnessLowerBound.draw();
        btnIncSampleFitnessLowerBound.draw();
        drawSampleLabels();
    }

}

void mousePressed() {
    if(btnCustomNodes.state) {
         if(btnCustomNodes.mouseIsOver()) {
            btnCustomNodes.state = false;
            
            problem = pm.nodes;
            paths = new Paths(pm.nodes, paths.size(), paths.mutationRate, btnFittestIsImmortal.state, paths.sampleFitnessPercentileLowerBound);
            generations = 0;

        } else if(pm.mouseIsOver()) {
            pm.add(map(mouseX-pm.x, 0.0, pm.w, 0.0, 1.0), map(mouseY-pm.y, 0.0, pm.h, 0.0, 1.0));
        }
    } else {
        if(btnAdd1Gen.mouseIsOver()) {
            btnAdd1Gen.state = true;
            generations +=1;
        } else if(btnAdd100Gen.mouseIsOver()) {
            btnAdd100Gen.state = true;
            generations +=100;
        } else if(btnAdd1000Gen.mouseIsOver()) {
            btnAdd1000Gen.state = true;
            generations +=1000;
        } else if(btnSort.mouseIsOver()) {
            btnSort.state = true;
            paths.sort();
        } else if(btnFittestIsImmortal.mouseIsOver()) {
            btnFittestIsImmortal.state = !btnFittestIsImmortal.state;
            paths.fittestIsImmortal = btnFittestIsImmortal.state;
        } else if(btnCustomNodes.mouseIsOver()) {
            btnCustomNodes.state = true;
            pm = new ProblemMaker(margin*2+fullBtnW, margin+titleSize, width-(margin*3+fullBtnW), height-(margin*2+titleSize));
        } else if(btnDecMutation.mouseIsOver()) {
            btnDecMutation.state = true;
            if(paths.mutationRate>0) paths.mutationRate -= mutationStep;
        } else if(btnIncMutation.mouseIsOver()) {
            btnIncMutation.state = true;
            if(paths.mutationRate<1) paths.mutationRate += mutationStep;
        } else if(btnDecPopulation.mouseIsOver()) {
            btnDecPopulation.state = true;
            if(paths.size()-populationStep<pdsNumRowCol*pdsNumRowCol) {
                paths.trimPopulationTo(pdsNumRowCol*pdsNumRowCol);
            } else {
                paths.trimPopulationTo(paths.size()-populationStep);
            }
        } else if(btnIncPopulation.mouseIsOver()) {
            btnIncPopulation.state = true;
            if(paths.size()==pdsNumRowCol*pdsNumRowCol && pdsNumRowCol*pdsNumRowCol<populationStep) {
                paths.increasePopulationTo(populationStep);
            } else {
                paths.increasePopulationTo(paths.size()+populationStep);
            }
        } else if(btnDecSampleFitnessLowerBound.mouseIsOver()) {
            btnDecSampleFitnessLowerBound.state = true;
            if(paths.sampleFitnessPercentileLowerBound>0) paths.sampleFitnessPercentileLowerBound += sampleFitnessPercentileLowerBoundStep;
        } else if(btnIncSampleFitnessLowerBound.mouseIsOver()) {
            btnIncSampleFitnessLowerBound.state = true;
            if(paths.sampleFitnessPercentileLowerBound<1) paths.sampleFitnessPercentileLowerBound -= sampleFitnessPercentileLowerBoundStep;
        }
    }
}

void mouseReleased() {
    btnAdd1Gen.state = false;
    btnAdd100Gen.state = false;
    btnAdd1000Gen.state = false;
    btnSort.state = false;
    
    btnDecMutation.state = false;
    btnIncMutation.state = false;
    btnDecPopulation.state = false;
    btnIncPopulation.state = false;
    btnDecSampleFitnessLowerBound.state = false;
    btnIncSampleFitnessLowerBound.state = false;
}

List<PVector> genProblem(int num) {
    List<PVector> nodes = new ArrayList<PVector>();
    for(int i=0; i<num; i++) {
        nodes.add(new PVector(random(1), random(1)));
    }
    
    return nodes;
}

void drawTitle() {
    fill(255);
    textAlign(LEFT, TOP);
    textSize(titleSize-10);
    text("Genetic Travelling Salesman, Generation: " + paths.generation + " of " + generations, margin, margin);
}

void drawMutationLabels() {
    fill(255);
    textAlign(CENTER, TOP);
    textSize(bannerTextSize-5);
    text("Mutation Rate", margin+fullBtnW/2, height-margin-fullBtnH-bannerTextSize);
    textAlign(CENTER, CENTER);
    textSize(bannerTextSize-10);
    text(int(paths.mutationRate*100)+"%", margin+fullBtnW/2, height-margin-fullBtnH/2);
}

void drawPopulationLabels() {
    fill(255);
    textAlign(CENTER, TOP);
    textSize(bannerTextSize-5);
    text("Population", margin+fullBtnW/2, height-margin-fullBtnH*2-bannerTextSize*2);
    textAlign(CENTER, CENTER);
    textSize(bannerTextSize-10);
    text(paths.size(), margin+fullBtnW/2, height-margin-fullBtnH/2-fullBtnH-bannerTextSize);
}

void drawSampleLabels() {
    fill(255);
    textAlign(CENTER, TOP);
    textSize(bannerTextSize-5);
    text("Sample From Top", margin+fullBtnW/2, height-margin-fullBtnH*3-bannerTextSize*3);
    textAlign(CENTER, CENTER);
    textSize(bannerTextSize-10);
    text(int((1-paths.sampleFitnessPercentileLowerBound)*100)+"%", margin+fullBtnW/2, height-margin-fullBtnH/2-fullBtnH*2-bannerTextSize*2);
}

void drawPathSpaces() {
    for(int i=0; i< pds.size(); i++) {
        if(i==paths.fittest) {
            pds.get(i).draw(problem, paths.get(i), #008080);
        } else {
            pds.get(i).draw(problem, paths.get(i), 255);
        }
    }
}
