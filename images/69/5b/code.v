module top_module(input [3:0] in, output reg [1:0] out);always @(*) begin
    case(in)
        4'b0001: out = 2'b01;
        4'b0010: out = 2'b10;
        4'b0100: out = 2'b11;
        4'b1000: out = 2'b00;
        4'b0011, 4'b0111, 4'b1111: out = 2'b10;
        4'b0101, 4'b1011, 4'b1101: out = 2'b11;
        4'b0110, 4'b1010, 4'b1100: out = 2'b10;
        default: out = 2'b00;
    endcase
end

endmodule