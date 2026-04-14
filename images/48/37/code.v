module top_module(
	input on,
	input num,
	output on_out
    );reg temp=1;
assign on_out=temp;

always @(*)
begin
	if(temp==1 && on==0) temp<=0;
	else if(temp==0 && on==1) 
	begin
		if(num) temp<=1;
	end
end

endmodule