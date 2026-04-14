module ripple_carry_adder (
    input [3:0] A,
    input [3:0] B,
    output [3:0] SUM,
    output C_OUT
);
    wire [4:0] carry; // Carry bits

    assign carry[0] = 0; // Initial carry-in is 0
    assign {carry[4], SUM} = A + B + carry; // Full adder logic
    assign C_OUT = carry[4]; // Final carry-out
endmodule