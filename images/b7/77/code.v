module top_module(
    input [3:0] num,
    output [3:0] twos_comp
);wire [3:0] complement;
assign complement = ~num + 1;

assign twos_comp = complement;

endmodule