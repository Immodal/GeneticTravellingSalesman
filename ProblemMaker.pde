class ProblemMaker {
    float x;
    float y;
    float w;
    float h;
    List<PVector> nodes;
    
    ProblemMaker(float x, float y, float w, float h) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.nodes = new ArrayList<PVector>();
    }
    
    void add(float x, float y) {
        this.nodes.add(new PVector(x, y));
    }
    
    void draw() {
        stroke(255);
        noFill();
        rect(x, y, w, h);
        
        for(PVector node: nodes) {
            ellipse(x+node.x*w, y+node.y*h, w*0.05, h*0.05);
        }
    }
    
    boolean mouseIsOver() {
        if (mouseX>x && mouseX<x+w && mouseY>y && mouseY<y+h) {
            return true;
        } else {
            return false;
        }
    }
}
