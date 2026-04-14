module top_module(
  input clk,       // clock input
  input d,         // data input
  input r,         // asynchronous reset input
  output reg q     // flip-flop output
);always @(posedge clk or negedge r) begin
    if (r == 0) begin
      q <= d;
    end else begin
      q <= 1'b1;
    end
  end

endmodule