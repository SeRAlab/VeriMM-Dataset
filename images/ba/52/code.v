module binary_to_gray(BIN, GRAY);
input [3:0] BIN;
output reg [3:0] GRAY;

always @(BIN) begin
    GRAY[3] = BIN[3];
    GRAY[2] = BIN[3] ^ BIN[2];
    GRAY[1] = BIN[2] ^ BIN[1];
    GRAY[0] = BIN[1] ^ BIN[0];
end

endmodule