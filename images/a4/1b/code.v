module top_module(clk, rst, U1, U2);input clk, rst;
output reg [31: 0]U1, U2;

reg [31:0] s0, s1, s2, s3, s4, s5, b1, b2;

parameter mask1 = 32'hfffffffe;
parameter mask2 = 32'hfffffff8;
parameter mask3 = 32'hfffffff0;

always @(posedge clk) begin
if((!rst) )
	begin
		b1 = ((( s0 << 13) ^ s0) >> 19);
		s0 = ((( s0 & mask1) << 12 ) ^ b1);
		b1 = ((( s1 << 2) ^ s1) >> 25);
		s1 = ((( s1 & mask2) << 4 ) ^ b1);
		b1 = ((( s2 << 3) ^ s2) >> 11);
		s2 = ((( s2 & mask3) << 17 ) ^ b1);
		
		b2 = ((( s3 << 13) ^ s3) >> 19);
        s3 = ((( s3 & mask1) << 12 ) ^ b2);
        b2 = ((( s4 << 2) ^ s4) >> 25);
        s4 = ((( s1 & mask2) << 4 ) ^ b2);
        b2 = ((( s5 << 3) ^ s5) >> 11);
        s5 = ((( s5 & mask3) << 17 ) ^ b2);
        
      
	 end
	else begin     
       s0 = 32'h7fffeeee;
       s1 = 32'h7ddddddd;
       s2 = 32'h7dddeeee;
       s3 = 32'h7fffffff;
       s4 = 32'h7eeeeeee;
       s5 = 32'h7dddcccc;
    end
    U1 = s0 ^ s1 ^ s2;
    U2 = s3 ^ s4 ^ s5;
end



endmodule