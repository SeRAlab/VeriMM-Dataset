module decoder_2to4(
    input [1:0] bin,
    output reg [3:0] dec
    );

    always @(*) begin
        case (bin)
            2'b00: dec = 4'b0001; // 00 -> 0001
            2'b01: dec = 4'b0010; // 01 -> 0010
            2'b10: dec = 4'b0100; // 10 -> 0100
            2'b11: dec = 4'b1000; // 11 -> 1000
            default: dec = 4'b0000; // Default to 0
        endcase
    end
endmodule