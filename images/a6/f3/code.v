module one_hot_decoder (
  input [1:0] a,
  output reg [3:0] b);

always @(*) begin
    b = 4'b0000;
    b[a] = 1'b1;
end
endmodule