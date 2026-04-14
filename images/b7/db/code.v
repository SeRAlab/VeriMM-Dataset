module top_module(
	 input CLK,
    input beep_flag1,
	 input beep_flag2,
    output beep
    );reg beep_value;
	always @(posedge CLK)
	begin
		if(beep_flag1||beep_flag2) beep_value <= 0;
		else beep_value <= 1;
	end
	assign beep = beep_value;
endmodule