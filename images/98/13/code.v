module top_module(
    input [3:0] IN,
    input select,
    output reg [6:0] OUT
);always @ (IN or select) begin
    if (select) begin
        case (IN)
            0: OUT = 7'b0000001;
            1: OUT = 7'b1001111;
            2: OUT = 7'b0010010;
            3: OUT = 7'b0000110;
            4: OUT = 7'b1001100;
            5: OUT = 7'b0100100;
            6: OUT = 7'b0100000;
            7: OUT = 7'b0001111;
            8: OUT = 7'b0000000;
            9: OUT = 7'b0000100;
            10: OUT = 7'b0001000;
            11: OUT = 7'b0000000;
            12: OUT = 7'b0110001;
            13: OUT = 7'b0000001;
            14: OUT = 7'b0110000;
            15: OUT = 7'b0111000;
            default: OUT = 7'b1111111; // Invalid input
        endcase
    end
    else begin
        OUT = 7'b1111110; // Turn off all segments
    end
end

// 4 enable switches //

endmodule