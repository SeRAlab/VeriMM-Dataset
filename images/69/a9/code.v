module priority_encoder_4bit (
    input en,
    input [3:0] in,
    output reg [1:0] bin_out
);

always @(*) begin
    if (!en) begin
        bin_out = 2'b00;
    end else begin
        casez (in)
            4'b1???: bin_out = 2'b11;
            4'b01??: bin_out = 2'b10;
            4'b001?: bin_out = 2'b01;
            4'b0001: bin_out = 2'b00;
            default: bin_out = 2'b00;
        endcase
    end
end

endmodule