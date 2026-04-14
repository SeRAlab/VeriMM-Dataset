module top_module (
    input [3:0] a, 
    input [3:0] b, 
    input sel, 
    output reg [3:0] y);always @(*) 
    case (sel)
        0: y = a & ~b;
        1: y = ~a & b;
    endcase
    
endmodule