module top_module(input signed [31:0] A, input signed [31:0] B, input CI, input BI, output signed [31:0] X, output signed [31:0] Y, output CO);parameter WIDTH = 32;

    wire [WIDTH:0] C;
    wire [WIDTH-1:0] S;
    wire [WIDTH-1:0] A_buf, B_buf;

    assign A_buf = A;
    assign B_buf = BI ? ~B : B;

    assign C[0] = CI;
    assign S = A_buf + B_buf + CI;

    assign CO = C[WIDTH];

    assign Y = S;
    assign X = A_buf ^ B_buf;

endmodule