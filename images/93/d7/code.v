module top_module(line, pixels);input [2:0] line;
    output reg [3:0] pixels;  // Change wire to reg

    always @*
        case(line)
            3'b000: pixels = 4'b1110;
            3'b001: pixels = 4'b1010;
            3'b010: pixels = 4'b1010;
            3'b011: pixels = 4'b1010;
            3'b100: pixels = 4'b1110;
            default: pixels = 4'b0000;
        endcase
endmodule