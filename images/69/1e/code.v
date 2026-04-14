module top_module(
    input [2:0] ABC,
    input EN,
    output reg [7:0] Y
);always @ (ABC, EN) begin
        case ({ABC, EN})
            4'b0001: Y = 8'b00000001;
            4'b0010: Y = 8'b00000010;
            4'b0011: Y = 8'b00000100;
            4'b0100: Y = 8'b00001000;
            4'b0101: Y = 8'b00010000;
            4'b0110: Y = 8'b00100000;
            4'b0111: Y = 8'b01000000;
            default: Y = 8'b00000000;
        endcase
    end

endmodule