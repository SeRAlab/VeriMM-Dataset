module twos_comp(
    input [3:0] in,
    output [3:0] out
);

wire [3:0] neg_in;
assign neg_in = ~in + 1;

assign out = (in[3] == 0) ? in : neg_in;

endmodule