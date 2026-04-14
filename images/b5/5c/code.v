module top_module (
    input [3:0] a, 
    input [3:0] b, 
    input sel, 
    output reg z);always @(*) 
    case (sel)
        0: z = (a == b) ? 1 : 0;
        1: z = (a != b) ? 1 : 0;
    endcase
    
endmodule