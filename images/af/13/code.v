module priority_encoder(
    input [2:0] in,
    output reg [1:0] pos
);

always @(*)
    casez (in)
        3'b1??: pos = 2'b10; // Highest '1' bit in position 2
        3'b01?: pos = 2'b01; // Highest '1' bit in position 1
        3'b001: pos = 2'b00; // Highest '1' bit in position 0
        default: pos = 2'b00; // Default case
    endcase

endmodule