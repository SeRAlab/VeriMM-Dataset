module top_module(clk, rstn, en, leds);parameter width=4;

  input clk;
  input rstn;
  input en;
  output reg [width-1:0] leds;

  always @(posedge clk, negedge rstn) begin
    if (~rstn)
      leds <= {width{1'b0}};
    else if (en)
      leds <= leds + 1'b1;
  end
endmodule