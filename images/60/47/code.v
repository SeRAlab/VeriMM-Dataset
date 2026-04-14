module binary_counter (
  input clk,
  input en,
  input rst,
  output reg [4:0] count);

always @(posedge clk or posedge rst) begin
    if (rst)
        count <= 5'b11111;
    else if (en)
        count <= count + 1;
end
endmodule