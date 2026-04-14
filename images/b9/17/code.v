module priority_encoder_8to3(
    input [7:0] in,   // 8-bit input.

    output [2:0] out  // 3-bit output indicating the position of the highest-order '1' bit.
);

reg [2:0] out_r; // Output register.

//------------------------------------------------
// Priority encoder operation
always @(*) begin
    casez (in)
        8'b10000000: out_r = 3'b111;
        8'b01111111: out_r = 3'b110;
        8'b00111111: out_r = 3'b101;
        8'b00011111: out_r = 3'b100;
        8'b00001111: out_r = 3'b011;
        8'b00000111: out_r = 3'b010;
        8'b00000011: out_r = 3'b001;
        8'b00000001: out_r = 3'b000;
        default: out_r = 3'b000; // Default case for all zeros
    endcase
end

assign out = out_r;

endmodule