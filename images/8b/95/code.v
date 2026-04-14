module top_module(
    input wire [2:0] vec, // 3-bit input for the multiplexer
    input wire select, // Select input for the multiplexer
    input [7:0] a, b, c, d, // 4 unsigned 8-bit input values for the functional module
    output wire [2:0] outv, // 3 output ports for the selected bit from the multiplexer
    output wire o2,
    output wire o1,
    output wire o0,
    output wire [7:0] min // 8-bit output representing the minimum value among the four input values
);// Multiplexer
assign outv = {vec[2] ? vec[2] : vec[1] ? vec[1] : vec[0], vec[2] ? vec[2] : vec[1] ? vec[1] : vec[0], vec[2] ? vec[2] : vec[1] ? vec[1] : vec[0]};
assign o2 = outv[2];
assign o1 = outv[1];
assign o0 = outv[0];

// Comparator and Multiplexer for minimum value
wire [7:0] min1, min2, min3;
assign min1 = a < b ? a : b;
assign min2 = c < d ? c : d;
assign min3 = min1 < min2 ? min1 : min2;
assign min = min3;

endmodule