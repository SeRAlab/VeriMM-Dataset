module lfsr (
  input clk,
  input rst,
  output reg [7:0] q);

always @(posedge clk or posedge rst) begin
    if (rst)
        q <= 8'b1;
    else
        q <= {q[6:0], q[7] ^ q[5] ^ q[4] ^ q[3]};
end
endmodule