module top_module(
  input clk, // clock signal
  input rst, // reset signal
  output reg [n-1:0] count // n-bit binary count
);parameter n = 4; // number of bits in the binary count
  
  always @(posedge clk) begin
    if (rst) begin
      count <= 0;
    end
    else if (count == 2**n-1) begin
      count <= 0;
    end
    else begin
      count <= count + 1;
    end
  end
  
endmodule