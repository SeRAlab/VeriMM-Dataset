module priority_encoder (
    input [4:0] S,
    output reg [2:0] Y
);
    always @(*) begin
        casez (S)
            5'b1????: Y = 3'b100; // S4 is active
            5'b01???: Y = 3'b011; // S3 is active
            5'b001??: Y = 3'b010; // S2 is active
            5'b0001?: Y = 3'b001; // S1 is active
            5'b0000?: Y = 3'b000; // S0 is active or no source
            default:  Y = 3'b000; // No active sources
        endcase
    end
endmodule