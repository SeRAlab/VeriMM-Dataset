module top_module(
  input clk,
  input en,
  input data_in,
  output reg [DEPTH-1:0] data_out
);parameter DEPTH = 0;
  parameter [DEPTH-1:0] INIT = 0;
  parameter CLKPOL = 1;
  parameter ENPOL = 2;

  always @(posedge clk)
  begin
    if (en == ENPOL)
    begin
      data_out <= {data_out[DEPTH-2:0], data_in};
    end
  end

  initial
  begin
    data_out <= INIT;
  end

endmodule