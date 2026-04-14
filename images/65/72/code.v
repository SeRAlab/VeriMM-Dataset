module encoder_8to3(
    input  [7:0] data_in,
    output reg [2:0] data_out
);

always @(*) begin
    case (data_in)
        8'b00000001: data_out = 3'b000;
        8'b00000010: data_out = 3'b001;
        8'b00000100: data_out = 3'b010;
        8'b00001000: data_out = 3'b011;
        8'b00010000: data_out = 3'b100;
        8'b00100000: data_out = 3'b101;
        8'b01000000: data_out = 3'b110;
        8'b10000000: data_out = 3'b111;
        default:     data_out = 3'b000;
    endcase
end

endmodule