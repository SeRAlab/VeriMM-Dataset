module top_module(
    input [3:0] A,
    input [3:0] B,
    input areset,
    output [3:0] S,
    output C
);reg [3:0] S_reg;
    reg C_reg;

    always @(*) begin
        if (areset) begin
            S_reg <= 4'b0;
            C_reg <= 1'b0;
        end
        else begin
            S_reg <= A + B + C_reg;
            C_reg <= (S_reg[3] & (A[3] ^ B[3])) | (A[3] & B[3]);
        end
    end

    assign S = S_reg;
    assign C = C_reg;

endmodule