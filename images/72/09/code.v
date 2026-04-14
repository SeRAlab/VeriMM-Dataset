module top_module(
    input [3:0] A,
    input [3:0] B,
    input C,
    output [4:0] S
);wire [3:0] sum;
    wire carry_out;

    // Full adder implementation
    function [1:0] full_adder;
        input A;
        input B;
        input Cin;
        begin
            full_adder = A + B + Cin;
        end
    endfunction

    assign {carry_out, sum[0]} = full_adder(A[0], B[0], C);
    assign {carry_out, sum[1]} = full_adder(A[1], B[1], carry_out);
    assign {carry_out, sum[2]} = full_adder(A[2], B[2], carry_out);
    assign {S[4], sum[3]} = full_adder(A[3], B[3], carry_out);

    // 2-to-1 multiplexer implementation
    function mux2;
        input A;
        input B;
        input S;
        begin
            mux2 = S ? B : A;
        end
    endfunction

    assign S[3] = mux2(sum[3], ~sum[3], C);
    assign S[2] = mux2(sum[2], ~sum[2], C);
    assign S[1] = mux2(sum[1], ~sum[1], C);
    assign S[0] = mux2(sum[0], ~sum[0], C);

endmodule