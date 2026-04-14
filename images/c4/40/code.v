module ripple_adder(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);

reg [3:0] S;
reg Cout;

assign S = A + B + Cin;

always @(*) begin
    if (S > 15) begin
        Cout = 1;
    end else begin
        Cout = 0;
    end
end

endmodule