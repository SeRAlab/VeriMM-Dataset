module carry_save_adder (
    input [3:0] A,
    input [3:0] B,
    input [3:0] Cin,
    output [3:0] S,
    output [3:0] C
);
    wire [3:0] S_temp;
    wire [3:0] C_temp;

    assign S_temp = A ^ B ^ Cin; // Sum bits
    assign C_temp = (A & B) | (B & Cin) | (Cin & A); // Carry bits

    assign S = S_temp;
    assign C = C_temp;

endmodule