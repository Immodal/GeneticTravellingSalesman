class Button {
    boolean state;
    float x;
    float y;
    float w;
    float h;
    float r;
    String text;
    float textSize;
    
    Button(boolean startingState, String text, float textSize, float x, float y, float w, float h, float r) {
        this.state = startingState;
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.r = r;
        this.text = text;
        this.textSize = textSize;
    }
    
    void draw() {
        if(state) {
            fill(#00F0F0);
        } else {
            fill(#008080);
        }
        stroke(255);
        rect(x, y, w, h, r);
        
        fill(0);
        textSize(textSize);
        textAlign(CENTER, CENTER);
        text(text, x+w/2, y+h/2);
    }
    
    boolean mouseIsOver() {
        if (mouseX>x && mouseX<x+w && mouseY>y && mouseY<y+h) {
            return true;
        } else {
            return false;
        }
    }
}
