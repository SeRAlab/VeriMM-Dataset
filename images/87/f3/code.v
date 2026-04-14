module multiplier_4bit(A, B, P);
    input [3:0] A;
    input [3:0] B;
    output [7:0] P;
    reg [7:0] P;

    always @(*) begin
        P = A * B;
    end
endmodule