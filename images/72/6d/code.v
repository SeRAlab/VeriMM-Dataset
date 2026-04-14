module top_module(
    input m0,
    input m1,
    input left_in,
    input right_in,
    input clr,
    input clk,
    input [3:0] p_in,
    output reg left_out,
    output reg right_out,
    output reg [3:0] p_out
    );reg [3:0] sreg;

always @ (posedge clk)
begin
	if (clr == 1'b1)
	begin
		sreg <= 4'b0000;
		left_out <= 1'b0;
		right_out <= 1'b0;
		p_out <= 4'b0000;
	end
	else if (m0 == 1'b0 && m1 == 1'b1)
	begin
		right_out = sreg[0];
		sreg = {left_in, sreg[3:1]};
		p_out = sreg;
	end
	else if (m0 == 1'b1 && m1 == 1'b0)
	begin
		left_out = sreg[3];
		sreg = {sreg[2:0], right_in};
		p_out = sreg;
	end
	else if (m0 == 1'b1 && m1 == 1'b1) 
	begin
		sreg = p_in;
		p_out = sreg;
	end
	else 
	begin
		p_out <= sreg;
	end
end


endmodule