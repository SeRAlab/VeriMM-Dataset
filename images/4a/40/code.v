module decoder_2to4(
    input                 enable,
    input       [1:0]     data_in,
    output   reg [3:0]    data_out
);

// Decoder logic
always @(*) begin
    if (!enable) begin
        data_out = 4'b0000;
    end else begin
        case (data_in)
            2'b00: data_out = 4'b0001;
            2'b01: data_out = 4'b0010;
            2'b10: data_out = 4'b0100;
            2'b11: data_out = 4'b1000;
            default: data_out = 4'b0000;
        endcase
    end
end

endmodule