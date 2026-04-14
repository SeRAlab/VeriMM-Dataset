module top_module(
    input [3:0] number,
    output reg [7:0] data
    );always@(*)
    begin
        case(number)
            0: data = 8'b0011_1111;
            1: data = 8'b0000_0110;
            2: data = 8'b0101_1011;
            3: data = 8'b0100_1111;
            4: data = 8'b0110_0110;
            5: data = 8'b0110_1101;
            6: data = 8'b0111_1101;
            7: data = 8'b0000_0111;
            8: data = 8'b0111_1111;
            9: data = 8'b0110_1111;
            10: data = 8'b0111_0111;
            11: data = 8'b1111_1100;
            12: data = 8'b0101_1000;
            13: data = 8'b0101_1110;
            14: data = 8'b0111_1001;
            15: data = 8'b0111_0001;
            default: data = 8'b0000_0000;
            endcase
    end
endmodule