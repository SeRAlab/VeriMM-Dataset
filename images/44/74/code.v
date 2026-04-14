module top_module (
  input clk,
  input load,
  input [15:0] data_in,
  output reg [15:0] q);

always @(posedge clk) begin
    if (load)
        q <= data_in;
end
endmodule