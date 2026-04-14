module top_module(input clk50,input stop,output [1:64] key);reg [1:10] dem;
reg [1:10] dem1;
always @(clk50)
begin
	if(stop==0) begin
       if(clk50==1) 
			begin
			if(dem==10'h152) dem=10'h050; else dem=dem+1;
			end
       else
       begin
	   if(dem1==10'h171) dem1=10'h070; else dem1=dem+1;
	   end

	end
end

assign key[21:30]= dem;
assign key[41:50]=dem1;
assign key[16:20]= dem[1:5];
assign key[11:15]=dem1[5:9];
assign key[6:10]= dem[2:6];
assign key[1:5]=dem1[4:8];
assign key[31:40]= dem[1:10];
assign key[51:60]=dem1[1:10];
assign key[61:64]= dem[3:6];endmodule