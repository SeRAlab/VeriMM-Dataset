module ring_counter (
  input clk,
  input rst,
  output reg [6:0] q);always @(posedge clk or posedge rst) begin
    if (rst)
        q <= 7'b0000001;
    else
        q <= {q[5:0], q[6]};
end
endmodule