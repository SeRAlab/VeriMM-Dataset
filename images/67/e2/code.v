module top_module (
    input [3:0] a, 
    input sel, 
    output reg out);always @(*) 
    case (sel)
        0: out = a[0];
        1: out = a[1];
    endcase
    
endmodule