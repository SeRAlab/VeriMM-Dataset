module reg16 (
  input clk,
  input load,
  input [15:0] data,
  output reg [15:0] q
);

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end
  end

endmodule