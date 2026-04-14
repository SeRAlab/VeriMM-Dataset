module top_module(
    input [7:0] in,
    output [7:0] out
);wire [7:0] and_outputs;
    wire [8:0] adder_outputs;

    assign and_outputs = {in[0] & 1'b1, in[1] & 1'b1, in[2] & 1'b1, in[3] & 1'b1, in[4] & 1'b1, in[5] & 1'b1, in[6] & 1'b1, in[7] & 1'b1};
    assign adder_outputs = {1'b0, and_outputs} + and_outputs;

    assign out = adder_outputs[7:0];

endmodule