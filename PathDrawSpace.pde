class PathDrawSpace {
    float x;
    float y;
    float w;
    float h;
    
    PathDrawSpace(float x, float y, float w, float h) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
    }
    
    void draw(List<PVector> nodes, Path path, int colour) {
        String pathString = "";
        for(int i=0; i<path.size(); i++) {
            pathString += String.valueOf(path.get(i)) + ", ";
            if(i!=0 && i % 14==0) pathString += "\n";
        }
        
        stroke(colour);
        noFill();
        rect(x, y, w, h);
        
        textSize(12);
        for(int i=0; i<nodes.size(); i++) {
            fill(colour);
            ellipse(x+nodes.get(i).x*w, y+nodes.get(i).y*h, w*0.05, h*0.05);
            fill(#FF0000);
            textAlign(CENTER, CENTER);
            text(i, x+nodes.get(i).x*w, y+nodes.get(i).y*h);
        }
        
        fill(colour);
        for(int i=0; i<path.size(); i++) {
            if(i!=path.size()-1) {
                line(x+nodes.get(path.get(i)).x*w, y+nodes.get(path.get(i)).y*h, x+nodes.get(path.get(i+1)).x*w, y+nodes.get(path.get(i+1)).y*h);
            }
        }
        
        fill(colour);
        textAlign(LEFT, TOP);
        text("Fitness: " + path.fitness +
           "\nPath: " + pathString , x+5, y);
    }
}
