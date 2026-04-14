module decoder_3_to_8 (
    input [2:0] A,
    output reg [7:0] Y
);
    always @(*) begin
        Y = 8'b00000000; // Default all outputs to low
        case (A)
            3'b000: Y[0] = 1'b1;
            3'b001: Y[1] = 1'b1;
            3'b010: Y[2] = 1'b1;
            3'b011: Y[3] = 1'b1;
            3'b100: Y[4] = 1'b1;
            3'b101: Y[5] = 1'b1;
            3'b110: Y[6] = 1'b1;
            3'b111: Y[7] = 1'b1;
            default: Y = 8'b00000000; // Just in case
        endcase
    end
endmodule