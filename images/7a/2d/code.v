module binary_down_counter (
  input clk,
  input en,
  input rst,
  output reg [13:0] count);

always @(posedge clk) begin
    if (rst)
        count <= 14'b11111111111111;
    else if (en)
        count <= count - 1;
end
endmodule