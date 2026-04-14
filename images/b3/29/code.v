module top_module(clk, rst_n, enable, count_up, q);input clk;
input rst_n;
input enable;
input count_up;
output reg [3:0] q;

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    q <= 4'b0000;
  end else if(enable) begin
    if(count_up) begin
      q <= q + 1;
    end else begin
      q <= q - 1;
    end
  end
end

endmodule