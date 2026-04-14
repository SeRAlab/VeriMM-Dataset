module top_module(
  input clk,
  input reset,
  input up_down,
  output reg [3:0] count_out
);always @(posedge clk or posedge reset) begin
    if (reset) begin
      count_out <= 4'h0;
    end else if (up_down) begin
      count_out <= count_out + 1;
    end else begin
      count_out <= count_out - 1;
    end
  end

endmodule