module priority_encoder_8to3(
    input [7:0] in,     // 8-bit input.
    input en,           // Enable signal to activate the encoder.

    output [2:0] out    // 3-bit binary output.
);

reg [2:0] out_r;

//------------------------------------------------
// Priority Encoder logic
always @(*) begin
    if (en) begin
        casex (in)
            8'b10000000: out_r = 3'b111;
            8'b01000000: out_r = 3'b110;
            8'b00100000: out_r = 3'b101;
            8'b00010000: out_r = 3'b100;
            8'b00001000: out_r = 3'b011;
            8'b00000100: out_r = 3'b010;
            8'b00000010: out_r = 3'b001;
            8'b00000001: out_r = 3'b000;
            default: out_r = 3'b000;
        endcase
    end else begin
        out_r = 3'b000;
    end
end

assign out = out_r;

endmodule