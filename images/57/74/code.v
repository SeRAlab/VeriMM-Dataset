module top_module(
	input [3:0] digit,
	output  [7:0] Seven_seg_display
);reg [7:0] Seven_Seg;


always @ (*) begin
case(digit)    
	4'h0: Seven_Seg = 8'b11000000;
    4'h1: Seven_Seg = 8'b11111001;
    4'h2: Seven_Seg = 8'b10100100;
    4'h3: Seven_Seg = 8'b10110000;
    4'h4: Seven_Seg = 8'b10011001;
    4'h5: Seven_Seg = 8'b10010010;
    4'h6: Seven_Seg = 8'b10000010;
    4'h7: Seven_Seg = 8'b11111000;
    4'h8: Seven_Seg = 8'b10000000;
    4'h9: Seven_Seg = 8'b10010000;
    default: Seven_Seg = 8'b11111111;
endcase
end



assign Seven_seg_display = Seven_Seg;

endmodule