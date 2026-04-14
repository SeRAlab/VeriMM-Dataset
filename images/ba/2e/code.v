module top_module(
  input clk,
  input resetn,
  input [15:0] max_count,
  output reg [15:0] count,
  output reg flag
);always @(posedge clk, negedge resetn) begin
    if (~resetn) begin
      count <= 0;
      flag <= 0;
    end else if (count == max_count) begin
      count <= 0;
      flag <= 1;
    end else begin
      count <= count + 1;
      flag <= 0;
    end
  end
  
endmodule