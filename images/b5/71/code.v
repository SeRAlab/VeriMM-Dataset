module top_module(input  clk, input btn_input, input reset, output btn_output);reg [19:0] counter;
reg flag;
reg out;
assign btn_output = out;

always @(posedge clk)begin
	if(reset)begin
		flag <=0;
		counter <=0;
	end
	else begin
		if(!btn_input)begin
			flag <=0;
			counter <=0;
		end
		else if(btn_input && !flag)begin
			counter <= counter+1;
			if(counter==20'd1048575)begin
				flag <=1;
				out <=1;
			end
		end
		else out<=0;
	end
end
endmodule