module full_adder_1bit (
    input wire A,
    input wire B,
    input wire Cin,
    output wire S,
    output wire Cout
    );

assign S = A ^ B ^ Cin;
assign Cout = (A & B) | (Cin & (A ^ B));

endmodule