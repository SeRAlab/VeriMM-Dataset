module top_module(
    input [3:0] A,
    output reg [3:0] B,
    output reg [3:0] C
);always @* begin
    case (A)
        4'b0000: begin B = 4'b0000; C = 4'b0000; end
        4'b0001: begin B = 4'b0000; C = 4'b0001; end
        4'b0010: begin B = 4'b0000; C = 4'b0010; end
        4'b0011: begin B = 4'b0000; C = 4'b0011; end
        4'b0100: begin B = 4'b0000; C = 4'b0100; end
        4'b0101: begin B = 4'b0000; C = 4'b0101; end
        4'b0110: begin B = 4'b0000; C = 4'b0110; end
        4'b0111: begin B = 4'b0000; C = 4'b0111; end
        4'b1000: begin B = 4'b0001; C = 4'b0000; end
        4'b1001: begin B = 4'b0001; C = 4'b0001; end
        4'b1010: begin B = 4'b0001; C = 4'b0010; end
        4'b1011: begin B = 4'b0001; C = 4'b0011; end
        4'b1100: begin B = 4'b0001; C = 4'b0100; end
        4'b1101: begin B = 4'b0001; C = 4'b0101; end
        4'b1110: begin B = 4'b0001; C = 4'b0110; end
        4'b1111: begin B = 4'b0001; C = 4'b0111; end
    endcase
end

endmodule