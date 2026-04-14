module top_module(
    input [15:0] in,
    output reg [4:0] out
);always @(*) begin
    case(in)
        16'h0000: out = 5'b11111;
        16'h0001: out = 5'b00000;
        16'h0002: out = 5'b00001;
        16'h0004: out = 5'b00010;
        16'h0008: out = 5'b00011;
        16'h0010: out = 5'b00100;
        16'h0020: out = 5'b00101;
        16'h0040: out = 5'b00110;
        16'h0080: out = 5'b00111;
        16'h0100: out = 5'b01000;
        16'h0200: out = 5'b01001;
        16'h0400: out = 5'b01010;
        16'h0800: out = 5'b01011;
        16'h1000: out = 5'b01100;
        16'h2000: out = 5'b01101;
        16'h4000: out = 5'b01110;
        16'h8000: out = 5'b01111;
        default: out = 5'b00000;
    endcase
end

endmodule