module top_module(
    input [3:0] IN,
    input [1:0] SHIFT,
    input MODE,
    output reg [3:0] Y
);always @(*) begin
        case (MODE)
            2'b00: Y = IN << SHIFT; // logical left shift
            2'b01: Y = IN >> SHIFT; // logical right shift
            2'b10: Y = (IN >> SHIFT) | (IN[3] << (4 - SHIFT)); // arithmetic right shift
            default: Y = 4'b0; // default case
        endcase
    end

endmodule