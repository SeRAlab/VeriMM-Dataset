module top_module (
  input clk,
  input load,
  input [15:0] data,
  output reg [15:0] q);

always @(posedge clk) begin
    if (load)
        q <= data;
    else begin
        q <= (q << 1) ^ (q >> 1);
    end
end
endmodule