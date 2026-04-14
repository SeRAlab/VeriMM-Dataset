module johnson_counter (
  input clk,
  input en,
  input rst,
  output reg [7:0] count);

always @(posedge clk) begin
    if (rst)
        count <= 8'b00000000;
    else if (en)
        count <= {count[6:0], ~count[7]};
end
endmodule