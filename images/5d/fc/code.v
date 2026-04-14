module top_module(
    input [4:0] top_rs_selclk_out2_par,
    output [1:0] new_signal
);wire [0:0] first_bit;
wire [0:0] last_bit;

assign first_bit = top_rs_selclk_out2_par[0];
assign last_bit = top_rs_selclk_out2_par[4];

assign new_signal = {last_bit, first_bit};

endmodule