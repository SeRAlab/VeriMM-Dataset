module left_rotator (
    input [3:0] D,
    output reg [3:0] C
);

    always @(*) begin
        C[0] = D[3];
        C[1] = D[0];
        C[2] = D[1];
        C[3] = D[2];
    end

endmodule