module top_module(
  input clk_in,
  output reg clk_out
);parameter n = 1; // number of times to divide the input clock signal by 2

reg [n-1:0] counter;
wire clk_edge;

assign clk_edge = clk_in ^ ~clk_in;

always @(posedge clk_edge) begin
  if (counter == (2**n)-1) begin
    clk_out <= ~clk_out;
    counter <= 0;
  end else begin
    counter <= counter + 1;
  end
end

endmodule