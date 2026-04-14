module top_module(a, b, c);input [7:0] a, b;
    output [15:0] c;
    
    wire [7:0] diff;
    
    assign diff = (a >= b) ? (a-b) : (b-a);
    
    assign c = {diff, (a >= b) ? b : a};
    
endmodule