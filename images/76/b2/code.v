module decoder_4to16(
    input               en         ,
    input [3:0]         binary_in  ,
    output reg [15:0]   decoded_out
);

always @(*) begin
    if (en) begin
        case (binary_in)
            4'b0000: decoded_out = 16'b0000000000000001;
            4'b0001: decoded_out = 16'b0000000000000010;
            4'b0010: decoded_out = 16'b0000000000000100;
            4'b0011: decoded_out = 16'b0000000000001000;
            4'b0100: decoded_out = 16'b0000000000010000;
            4'b0101: decoded_out = 16'b0000000000100000;
            4'b0110: decoded_out = 16'b0000000001000000;
            4'b0111: decoded_out = 16'b0000000010000000;
            4'b1000: decoded_out = 16'b0000000100000000;
            4'b1001: decoded_out = 16'b0000001000000000;
            4'b1010: decoded_out = 16'b0000010000000000;
            4'b1011: decoded_out = 16'b0000100000000000;
            4'b1100: decoded_out = 16'b0001000000000000;
            4'b1101: decoded_out = 16'b0010000000000000;
            4'b1110: decoded_out = 16'b0100000000000000;
            4'b1111: decoded_out = 16'b1000000000000000;
            default: decoded_out = 16'b0000000000000000;
        endcase
    end else begin
        decoded_out = 16'b0000000000000000;
    end
end

endmodule