module top_module(
  input [31:0] data,
  input [23:0] rdaddress,
  input [23:0] wraddress,
  input wrclock,
  input wren,
  output reg [31:0] q
);parameter ARRAY_DEPTH = 2048;

  reg [31:0] mem_array [ARRAY_DEPTH-1:0];

  always @(posedge wrclock) begin
    if (wren) begin
      mem_array[wraddress] <= data;
    end
  end

  always @(*) begin
    if (rdaddress < ARRAY_DEPTH) begin
      q <= mem_array[rdaddress];
    end
    else begin
      q <= 32'dX;
    end
  end

endmodule