module binary_to_gray (
  input [2:0] binary,
  output reg [2:0] gray);always @(*) begin
    gray[2] = binary[2];
    gray[1] = binary[2] ^ binary[1];
    gray[0] = binary[1] ^ binary[0];
end

endmodule