module rsa_encrypt (
    input [7:0] P,
    input [7:0] E,
    output [15:0] C
);
    wire [15:0] P_extended;
    wire [15:0] result;

    assign P_extended = {8'b0, P}; // Extend P to 16 bits
    // Perform modular exponentiation (naive approach)
    assign result = (P_extended ** E) % 16'h0101; // 65537 is 0x0101 in hex

    assign C = result;
endmodule