module top_module(
    input [3:0] SEL,
    output reg [7:0] OUT  // Change to 'reg' to allow assignment in always block
);always @(*) begin
    case(SEL)
        4'h0: OUT = 8'b00000001;
        4'h1: OUT = 8'b00000010;
        4'h2: OUT = 8'b00000100;
        4'h3: OUT = 8'b00001000;
        4'h4: OUT = 8'b00010000;
        4'h5: OUT = 8'b00100000;
        4'h6: OUT = 8'b01000000;
        4'h7: OUT = 8'b10000000;
        4'h8: OUT = 8'b00000000;
        4'h9: OUT = 8'b11111111;
        4'ha: OUT = 8'b11111110;
        4'hb: OUT = 8'b11111100;
        4'hc: OUT = 8'b11111000;
        4'hd: OUT = 8'b11110000;
        4'he: OUT = 8'b11100000;
        4'hf: OUT = 8'b11000000;
        default: OUT = 8'b00000000;
    endcase
end

endmodule