module top_module (
    input [7:0] a, 
    input [7:0] b, 
    input sel, 
    output reg [7:0] z);always @(*) 
    case (sel)
        0: z = a & b;
        1: z = a | b;
    endcase
    
endmodule