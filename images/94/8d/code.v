module decoder_2to4(
    input               en         ,
    input [1:0]         binary_in  ,
    output reg [3:0]    decoded_out
);

always @(*) begin
    if (en) begin
        case (binary_in)
            2'b00: decoded_out = 4'b0001;
            2'b01: decoded_out = 4'b0010;
            2'b10: decoded_out = 4'b0100;
            2'b11: decoded_out = 4'b1000;
            default: decoded_out = 4'b0000;
        endcase
    end else begin
        decoded_out = 4'b0000;
    end
end

endmodule