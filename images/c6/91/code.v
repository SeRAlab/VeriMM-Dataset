module bin2gray(
  input [3:0] binary,
  output reg [3:0] gray
);

  always @ (binary) begin
    gray[3] = binary[3];
    gray[2] = binary[3] ^ binary[2];
    gray[1] = binary[2] ^ binary[1];
    gray[0] = binary[1] ^ binary[0];
  end

endmodule
