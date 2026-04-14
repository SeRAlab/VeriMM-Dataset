module top_module(
    input [3:0] bin, 
    output reg [6:0] disp 
);always @(bin) begin
        case(bin)
            4'b0000: begin disp <= 7'b1000000; end 
            4'b0001: begin disp <= 7'b1111001; end 
            4'b0010: begin disp <= 7'b0100100; end 
            4'b0011: begin disp <= 7'b0110000; end 
            4'b0100: begin disp <= 7'b0011001; end 
				4'b0101: begin disp <= 7'b0010010; end 
				4'b0110: begin disp <= 7'b0000010; end 
				4'b0111: begin disp <= 7'b1111000; end 
				4'b1000: begin disp <= 7'b0000000; end 
				4'b1001: begin disp <= 7'b0011000; end 
            default: begin disp <= 7'b0000110; end 
        endcase
    end
endmodule