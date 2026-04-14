module top_module(
    input [15:0] in,
    input [3:0] sel,
    input [7:0] D,
    output [7:0] out,
    output [2:0] EN
);// 16-to-1 multiplexer
    wire [7:0] mux_out;
    assign mux_out = sel[3] ? in[15:8] : in[7:0];

    assign out = sel[2] ? mux_out[7:0] : mux_out[15:8];

    // 8-bit priority encoder
    wire [2:0] priority_out;
    assign priority_out = D[7] ? 3 : D[6] ? 2 : D[5] ? 1 : D[4] ? 0 : D[3] ? 3 : D[2] ? 2 : D[1] ? 1 : D[0] ? 0 : 3;

    assign EN = priority_out;

    // Bitwise OR module
    wire [7:0] or_out;
    assign or_out = mux_out | priority_out;

endmodule