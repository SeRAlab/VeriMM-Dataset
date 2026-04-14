module top_module(
  input clk,
  input reset,
  input [3:0] modulus,
  output reg [3:0] count
);always @(posedge clk or posedge reset) begin
    if (reset) begin
      count <= 4'b0;
    end else if (count == modulus) begin
      count <= 4'b0;
    end else begin
      count <= count + 1;
    end
  end

endmodule