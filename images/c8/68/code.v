module adder_16bit (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output reg [15:0] S,
    output reg Cout
);

    always @(*) begin
        S = A + B + Cin;
        Cout = (S > 65535) ? 1 : 0;
    end

endmodule