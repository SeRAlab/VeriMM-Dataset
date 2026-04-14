module binary_counter (
  input clk,
  input rst,
  input load,
  input [3:0] load_value,
  output reg [3:0] count);

always @(posedge clk or posedge rst) begin
    if (rst)
        count <= 4'b0000;
    else if (load)
        count <= load_value;
    else
        count <= count + 1;
end
endmodule