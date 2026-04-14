module top_module(
    input [3:0] A,
    input [3:0] B,
    input Cn,
    output reg [3:0] S,
    output reg V
);// Calculate the sum/difference
    always @(*) begin
        if (Cn == 0) begin
            S = A + B;
        end else begin
            S = A - B;
        end
    end

    // Detect overflow
    always @(*) begin
        if (Cn == 0) begin
            if (A[3] & B[3] & ~S[3]) begin
                V = 1;
            end else if (~A[3] & ~B[3] & S[3]) begin
                V = 1;
            end else begin
                V = 0;
            end
        end else begin
            if (A[3] & ~B[3] & ~S[3]) begin
                V = 1;
            end else if (~A[3] & B[3] & S[3]) begin
                V = 1;
            end else begin
                V = 0;
            end
        end
    end

endmodule