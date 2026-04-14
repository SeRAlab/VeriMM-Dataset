module top_module(
  input CLK_125MHZ_FPGA,
  input [3:0] BUTTONS,
  input [1:0] SWITCHES,
  output [5:0] LEDS
);wire a, b;
  and(a, BUTTONS[0], BUTTONS[1]);
  and(b, BUTTONS[2], BUTTONS[3]);
  and(LEDS[1], a, b);
  assign LEDS[5:2] = 0;
  assign LEDS[0] = 0;
endmodule