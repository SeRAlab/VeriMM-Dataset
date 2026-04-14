module top_module (
    input [7:0] a, 
    input [7:0] b, 
    input sel, 
    output reg [7:0] y);always @(*) 
    case (sel)
        0: y = ~(a & b);
        1: y = ~(a | b);
    endcase
    
endmodule