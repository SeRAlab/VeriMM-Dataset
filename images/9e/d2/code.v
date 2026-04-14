module top_module (
    input [3:0] a,
    input [1:0] sel,
    output reg out);always @(*)
    case (sel)
        2'b00: out = a[0];
        2'b01: out = a[1];
        2'b10: out = a[2];
        2'b11: out = a[3];
    endcase

endmodule