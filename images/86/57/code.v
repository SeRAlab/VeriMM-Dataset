module johnson_counter (
  input clk,
  input en,
  input rst,
  output reg [13:0] count);

always @(posedge clk or posedge rst) begin
    if (rst)
        count <= 14'b00000000000000;
    else if (en)
        count <= {count[12:0], ~count[13]};
end
endmodule