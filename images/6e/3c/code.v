module top_module(
    input [3:0] in,
    output wire [15:0] out
    );assign out = {{12{in[3]}},in};
endmodule