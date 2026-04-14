module top_module(
   input [3:0] N,
   output reg [6:0] SEG
   );always @(*) 
begin
	case(N)
        4'd0: SEG = 7'b0000001;
        4'd1: SEG = 7'b1001111;
        4'd2: SEG = 7'b0010010;
        4'd3: SEG = 7'b0000110;
        4'd4: SEG = 7'b1001100;
        4'd5: SEG = 7'b0100100;
        4'd6: SEG = 7'b0100000;
        4'd7: SEG = 7'b0001111;
        4'd8: SEG = 7'b0000000;
        4'd9: SEG = 7'b0000100;
        4'd10: SEG = 7'b0001000;
        4'd11: SEG = 7'b1100000;
        4'd12: SEG = 7'b0110001;
        4'd13: SEG = 7'b1000010;
        4'd14: SEG = 7'b0110000;
        4'd15: SEG = 7'b0111000;
        default: SEG = 7'b1111111;
	endcase
end
endmodule