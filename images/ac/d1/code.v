module ring_counter (
  input clk,
  input en,
  input rst,
  output reg [5:0] count);

always @(posedge clk or posedge rst) begin
    if (rst)
        count <= 6'b000001;
    else if (en)
        count <= {count[4:0], count[5]};
end
endmodule