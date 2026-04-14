module down_counter (
  input clk,
  input rst,
  input load,
  input [2:0] load_value,
  output reg [2:0] count);

always @(posedge clk or posedge rst) begin
    if (rst)
        count <= 3'b111;
    else if (load)
        count <= load_value;
    else
        count <= count - 1;
end
endmodule