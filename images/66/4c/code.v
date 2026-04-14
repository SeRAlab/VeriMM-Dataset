module top_module(
    input [3:0] BIN,
    output reg [3:0] BCD_HI,
    output reg [3:0] BCD_LO
);always @(*) begin
    case(BIN)
        4'b0000: begin BCD_HI = 4'b0000; BCD_LO = 4'b0000; end
        4'b0001: begin BCD_HI = 4'b0000; BCD_LO = 4'b0001; end
        4'b0010: begin BCD_HI = 4'b0000; BCD_LO = 4'b0010; end
        4'b0011: begin BCD_HI = 4'b0000; BCD_LO = 4'b0011; end
        4'b0100: begin BCD_HI = 4'b0000; BCD_LO = 4'b0100; end
        4'b0101: begin BCD_HI = 4'b0000; BCD_LO = 4'b0101; end
        4'b0110: begin BCD_HI = 4'b0000; BCD_LO = 4'b0110; end
        4'b0111: begin BCD_HI = 4'b0000; BCD_LO = 4'b0111; end
        4'b1000: begin BCD_HI = 4'b0001; BCD_LO = 4'b0000; end
        4'b1001: begin BCD_HI = 4'b0001; BCD_LO = 4'b0001; end
        4'b1010: begin BCD_HI = 4'b0001; BCD_LO = 4'b0010; end
        4'b1011: begin BCD_HI = 4'b0001; BCD_LO = 4'b0011; end
        4'b1100: begin BCD_HI = 4'b0001; BCD_LO = 4'b0100; end
        4'b1101: begin BCD_HI = 4'b0001; BCD_LO = 4'b0101; end
        4'b1110: begin BCD_HI = 4'b0001; BCD_LO = 4'b0110; end
        4'b1111: begin BCD_HI = 4'b0001; BCD_LO = 4'b0111; end
    endcase
end

endmodule