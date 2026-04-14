module top_module(
  input clk,
  output reg out_clk // Change output to reg type
);parameter n = 2; // division factor
  
  reg [31:0] count = 0; // counter to count up to n-1
  
  always @(posedge clk) begin
    if (count == n-1) begin
      count <= 0;
      out_clk <= ~out_clk; // toggle output clock signal
    end
    else begin
      count <= count + 1;
    end
  end
  
endmodule