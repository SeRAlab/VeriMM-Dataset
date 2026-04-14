module gray_code (
    input [3:0] D,
    output reg [3:0] G
);

always @ (D) begin
    G[3] = D[3];
    G[2] = D[3] ^ D[2];
    G[1] = D[2] ^ D[1];
    G[0] = D[1] ^ D[0];
end

endmodule