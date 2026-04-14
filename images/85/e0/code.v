module top_module(

input [15:0] len,
input [3:0] choose,
output reg[7:0] threshhold





    );always @(*)
begin
	case(choose)
	4'h1: threshhold <= (len[7:0] != 8'h0) ? len[15:8] : len[15:8] - 1;
	4'h2: threshhold <= (len[7:0] != 8'h0) ? len[15:6] : len[15:6] - 1;
	4'h4: threshhold <= (len[7:0] != 8'h0) ? len[15:8] : len[15:8] - 1;
	4'h8: threshhold <= (len[7:0] != 8'h0) ? len[15:8] : len[15:8] - 1;
	default: threshhold <= (len[7:0] != 8'h0) ? len[15:8] : len[15:8] - 1;
	endcase
end    
    
    
    
    
endmodule