module top_module(
    input [7:0] in,
    output reg [2:0] pos
);reg [7:0] gray;
reg [2:0] binary;

// Binary-to-Gray code converter
always @(*) begin
    gray[0] = in[0];
    gray[1] = in[0] ^ in[1];
    gray[2] = in[1] ^ in[2];
    gray[3] = in[2] ^ in[3];
    gray[4] = in[3] ^ in[4];
    gray[5] = in[4] ^ in[5];
    gray[6] = in[5] ^ in[6];
    gray[7] = in[6] ^ in[7];
end

// Gray-to-binary code converter
always @(*) begin
    binary[2] = gray[7];
    binary[1] = binary[2] ^ gray[6];
    binary[0] = binary[1] ^ gray[5];
end

// Priority encoder
always @(*) begin
    if (binary[2]) pos = 3;
    else if (binary[1]) pos = 2;
    else if (binary[0]) pos = 1;
    else pos = 0;
end

endmodule