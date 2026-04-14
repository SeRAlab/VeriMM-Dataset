module top_module(
  input clk,
  input rst,
  input en,
  input load,
  output reg [3:0] q,
  output reg [3:0] q_bar
);always @(posedge clk) begin
    if (rst) begin
      q <= 4'b0000;
    end else if (en) begin
      q <= q + 1;
    end else if (load) begin
      q <= {q_bar[3], q_bar[2], q_bar[1], q_bar[0]};
    end
  end

  assign q_bar = ~q;

endmodule