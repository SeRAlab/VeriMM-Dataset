module top_module(data_in,result);input [2:0]data_in;
output reg[7:0]result;
reg[3:0]SEL;
always@(*)
 begin
 SEL={data_in[2],data_in[1],data_in[0]};
 if(SEL==0)
    result = 8'b00000001;
 else if(SEL==1)
    result = 8'b00000010;
 else if(SEL==2)
    result = 8'b00000100;
	 else if(SEL==3)
    result = 8'b00001000;
	 else if(SEL==4)
    result = 8'b00010000;
	 else if(SEL==5)
    result = 8'b00100000;
	 else if(SEL==6)
    result = 8'b01000000;
	 else if(SEL==7)
    result = 8'b10000000;
 end
endmodule