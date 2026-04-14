module top_module (
  input clk,
  input shift_left,
  input shift_right,
  input [7:0] data_in,
  output reg [7:0] q);
  
always @(posedge clk) begin
    if (shift_left)
        q <= q << 1;
    else if (shift_right)
        q <= q >> 1;
    else
        q <= data_in;
end
endmodule