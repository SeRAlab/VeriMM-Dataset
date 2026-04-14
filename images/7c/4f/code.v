module top_module (
    input [3:0] k,
    output [3:0] l);

assign l = k << 2;

endmodule