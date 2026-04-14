module top_module(
    PAD,
    CLK,
    Y
);/* synthesis syn_black_box */
/* synthesis black_box_pad_pin ="PAD" */
/* synthesis multicycle_pulse = CLK */

input PAD;
input CLK;
output Y;

parameter ACT_PIN = "";
parameter ACT_CONFIG = 1'b0;

assign Y = PAD;

endmodule