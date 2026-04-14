module top_module(
  input clk,
  input rst,
  input load,
  input D,
  output reg Q
);always @(posedge clk or negedge rst) begin
    if (~rst) begin
      Q <= 1'b0;
    end else if (load) begin
      Q <= D;
    end else begin
      Q <= Q + D;
    end
  end

endmodule