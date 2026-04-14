module binary_converter (
  input [3:0] input_num,
  output reg [7:0] binary_num
);

always @(*) begin
  binary_num = {4'b0000, input_num};
end

endmodule
