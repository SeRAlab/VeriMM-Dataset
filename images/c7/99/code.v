module gray_to_binary (
    input [3:0] G,
    output reg [3:0] B
);

always @* begin
    B[3] = G[3];
    B[2] = G[3] ^ G[2];
    B[1] = G[2] ^ G[1];
    B[0] = G[1] ^ G[0];
end

endmodule