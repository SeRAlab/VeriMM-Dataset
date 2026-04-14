module top_module(
    input [7:0] in,
    output parity);wire [7:0] xor_out;
    wire [3:0] mux_sel;

    assign xor_out = in ^ 8'b11111111;
    assign mux_sel = {in[6:4], in[2:0]};

    assign parity = {mux_sel[2], mux_sel[1], mux_sel[0], xor_out[mux_sel], 1'b0} ^ 9'b111111111;

endmodule