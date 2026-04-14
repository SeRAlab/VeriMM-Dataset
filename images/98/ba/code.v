module top_module(
    an,
    seg
    );output [6:0]seg;
    output [7:0]an;
    
    assign an[7:0]=~8'b00000001;
    assign seg = 7'b0010000;
    
endmodule