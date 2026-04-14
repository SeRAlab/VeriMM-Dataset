module gray_code_counter (
  input clk,
  input en,
  input rst,
  output reg [15:0] gray);

always @(posedge clk) begin
    if (rst)
        gray <= 16'b0000000000000000;
    else if (en)
        gray <= gray ^ (gray + 1);
end
endmodule