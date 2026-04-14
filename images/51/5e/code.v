module top_module(
  input clk,
  input reset,
  input control,
  input [15:0] data,
  output reg [15:0] q
);always @(posedge clk, negedge reset) begin
    if (reset == 0) begin
      q <= 16'b0;
    end else if (control == 1) begin
      q <= data;
    end else begin
      q <= {q[14:0], 1'b0};
    end
  end

endmodule