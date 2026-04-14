module top_module (
    input [7:0] a, 
    input [7:0] b, 
    input sel, 
    output reg [3:0] out);always @(*) 
    case (sel)
        0: out = a[3:0] + b[3:0];
        1: out = a[7:4] + b[7:4];
    endcase
    
endmodule