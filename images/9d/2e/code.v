module top_module(
  input data_in,
  input clk_in,
  output reg data_out,
  output reg clk_out
);parameter N = 2; // frequency division factor

reg [N-1:0] counter;
reg clk_out_div;

always @(posedge clk_in) begin
  // implement two-stage synchronizer here
  data_out <= #1 data_in;
  data_out <= #1 data_out;
end

always @(posedge clk_in) begin
  // implement frequency divider here
  if (counter == N-1) begin
    counter <= 0;
    clk_out_div <= ~clk_out_div;
  end else begin
    counter <= counter + 1;
  end
end

assign clk_out = clk_out_div;

endmodule