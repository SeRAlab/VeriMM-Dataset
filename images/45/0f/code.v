module top_module(clk, en, resetn,loadseed_i,seed_i,number_o);input clk;
input resetn;
input en; 
input loadseed_i;
input [31:0] seed_i;
output [31:0] number_o;

wire [31:0] number_o;

reg [31:0] c_b1, c_b2, c_b3;
reg [31:0] c_s1, c_s2, c_s3;

reg [31:0] r_s1, r_s2, r_s3;

assign number_o = r_s1 ^ r_s2 ^ r_s3;

always @(loadseed_i or seed_i or r_s1 or r_s2 or r_s3)
begin
	if(loadseed_i)
	begin
		c_b1 = 32'b0;
		c_s1 = seed_i;
		c_b2 = 32'b0;
		c_s2 = {seed_i[5:0], seed_i[17], seed_i[18], seed_i[19], seed_i[20], seed_i[25:21], seed_i[31:26], seed_i[16:6]} ^ 32'd1493609598;
		c_b3 = 32'b0;
		c_s3 = {seed_i[23:16], seed_i[5], seed_i[6], seed_i[7], seed_i[15:8], seed_i[4:0], seed_i[31:24]} ^ 32'd3447127471;
	end
	else
	begin
		c_b1 = (((r_s1 << 13) ^ r_s1) >> 19);
		c_s1 = (((r_s1 & 32'd4294967294) << 12) ^ c_b1);
		c_b2 = (((r_s2 << 2) ^ r_s2) >> 25);
		c_s2 = (((r_s2 & 32'd4294967288) << 4) ^ c_b2);
		c_b3 = (((r_s3 << 3) ^ r_s3) >> 11);
		c_s3 = (((r_s3 & 32'd4294967280) << 17) ^ c_b3);
	end
end



always @(posedge clk or negedge resetn)
   begin
   if (!resetn )
      begin
      r_s1 <= 32'b0;
	  r_s2 <= 32'b0;
	  r_s3 <= 32'b0;
      end
   else if (en)   
      begin
		  r_s1 <= c_s1;
		  r_s2 <= c_s2;
		  r_s3 <= c_s3;
	  end
   end

endmodule