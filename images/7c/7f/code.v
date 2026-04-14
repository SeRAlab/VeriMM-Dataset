module top_module(
  input [31:0] cnt_max,
  input [31:0] cnt_min,
  output [31:0] cnt_value,
  input clr,
  input inc_dec,
  input cnten,
  input clk
);reg [31:0] cnt;

  always @(posedge clk)
    if (inc_dec && clr)
      cnt <= cnt_min;
    else if ((!inc_dec) && clr)
      cnt <= cnt_max;
    else if (inc_dec && (cnt == cnt_max))
      cnt <= cnt_min;
    else if ((!inc_dec) && (cnt == cnt_min))
      cnt <= cnt_max;
    else if (inc_dec && cnten)
      cnt <= cnt + 1;
    else if ((!inc_dec) && cnten)
      cnt <= cnt - 1;
    else 
      cnt <= cnt;

    assign cnt_value = cnt;endmodule