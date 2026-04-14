module priority_encoder_2bit(
    input [3:0] in,     // 4-bit input.
    input en,           // Enable signal to activate the encoder.

    output [1:0] out    // 2-bit binary output.
);

reg [1:0] out_r;

//------------------------------------------------
// Priority Encoder logic
always @(*) begin
    if (en) begin
        if (in[3]) begin
            out_r = 2'b11;
        end else if (in[2]) begin
            out_r = 2'b10;
        end else if (in[1]) begin
            out_r = 2'b01;
        end else if (in[0]) begin
            out_r = 2'b00;
        end else begin
            out_r = 2'b00;
        end
    end else begin
        out_r = 2'b00;
    end
end

assign out = out_r;

endmodule