module top_module(
    input [7:0] in,
    output reg [7:0] out,
    input direction,
    input [2:0] shift
    );always @(*)
	begin
	
	if(direction)
	begin
	
		if(shift[2])
		begin
		out = { in[3:0],in[7:4]};
		end 
		else if(shift[1])
		begin
		out = { in[1:0],in[7:2]};
		end 
		else if(shift[0])
		begin
		out = { in[0:0],in[7:1]};
		end 
		else
		out = in;
	end
	
	else
		begin
		if(shift[2])
		begin
		out = { in[3:0],in[7:4]};
		end 
		else if(shift[1])
		begin
		out = { in[5:0],in[7:6]};
		end 
		else if(shift[0])
		begin
		out = { in[6:0],in[7:7]};
		end
		else
		out = in;
		end
	
	end
	endmodule