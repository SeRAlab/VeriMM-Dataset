module top_module(
    input [3:0] binary,
    output reg [3:0] twos_comp
);assign twos_comp = (~binary) + 1;

endmodule