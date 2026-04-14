module binary_to_gray (
    input [2:0] B,
    output reg [2:0] G
);

    always @ (B) begin
        G[0] = B[0] ^ B[1];
        G[1] = B[1] ^ B[2];
        G[2] = B[2];
    end

endmodule