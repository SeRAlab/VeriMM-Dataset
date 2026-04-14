module top_module(
    input [31:0] A,
    input [31:0] B,
    input [31:0] Cin,
    output [31:0] Sum,
    output Cout
);wire [31:0] c;
    wire [31:0] s;

    assign c[0] = Cin;
    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin
            assign s[i] = A[i] ^ B[i] ^ c[i];
            assign c[i+1] = (A[i] & B[i]) | (A[i] & c[i]) | (B[i] & c[i]);
        end
    endgenerate

    assign s[31] = A[31] ^ B[31] ^ c[31];
    assign Cout = (A[31] & B[31]) | (A[31] & c[31]) | (B[31] & c[31]);

    assign Sum = s;

endmodule