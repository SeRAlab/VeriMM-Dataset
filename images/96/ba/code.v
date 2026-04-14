module top_module(input wire [1:0] D0, D1,
    input wire S,
    output wire [1:0] Q);assign Q = S? D1 : D0;

endmodule