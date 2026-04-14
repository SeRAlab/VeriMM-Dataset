module top_module (
    input [3:0] a, 
    input sel, 
    output reg [3:0] y);always @(*) 
    case (sel)
        0: y = a << 1;
        1: y = a >> 1;
    endcase
    
endmodule