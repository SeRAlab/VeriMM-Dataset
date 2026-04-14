module priority_encoder_4to2(
    input [3:0] in,
    output reg [1:0] out
);

always @(*)
    casez (in)
        4'b1???: out = 2'b11; // Highest priority
        4'b01??: out = 2'b10;
        4'b001?: out = 2'b01;
        4'b0001: out = 2'b00; // Lowest priority
        default: out = 2'b00; // Default case
    endcase

endmodule