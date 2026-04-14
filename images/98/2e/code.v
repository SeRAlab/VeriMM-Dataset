module top_module(number, clk, reset);output reg [2:0] number;
input clk, reset;

wire feedback;

reg [12:0] out;

    
























assign feedback = ~(out[12] ^ out[3] ^ out[2] ^ out[0]);
always @(posedge clk)
  begin
    if (reset)
      out <= 13'b0;
    else
      out <= {out[11:0],feedback};
      number <= out[2:0];
  end


endmodule