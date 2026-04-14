module gray_to_binary(
    input [2:0] gray,
    output reg [2:0] binary);

always @* begin
    binary[2] = gray[2];
    binary[1] = gray[2] ^ gray[1];
    binary[0] = gray[2] ^ gray[1] ^ gray[0];
end

endmodule