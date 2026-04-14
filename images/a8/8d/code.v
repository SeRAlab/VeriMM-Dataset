module top_module(input wire clk, input wire [6:0] data_in, output reg [7:0] bcd);reg [6:0] data;
	always @(posedge clk)
		data<=data_in;
	always@(*) 
	begin
		bcd=0;
		if (data>=90)
			begin
				bcd[7:4]=9;
				bcd[3:0]=data-7'd90;
			end
		else if (data>=80)
			begin
				bcd[7:4]=8;
				bcd[3:0]=data-7'd80;
			end	
		else if (data>=70)
			begin
				bcd[7:4]=7;
				bcd[3:0]=data-7'd70;
			end	
		else if (data>=60)
			begin
				bcd[7:4]=6;
				bcd[3:0]=data-7'd60;
			end	
		else if (data>=50)
			begin
				bcd[7:4]=5;
				bcd[3:0]=data-7'd50;
			end	
		else if (data>=40)
			begin
				bcd[7:4]=4;
				bcd[3:0]=data-7'd40;
			end	
		else if (data>=30)
			begin
				bcd[7:4]=3;
				bcd[3:0]=data-7'd30;
			end	
		else if (data>=20)
			begin
				bcd[7:4]=2;
				bcd[3:0]=data-7'd20;
			end	
		else if (data>=10)
			begin
				bcd[7:4]=1;
				bcd[3:0]=data-7'd10;
			end	
		else 	bcd[3:0]=data[3:0];
	end
endmodule