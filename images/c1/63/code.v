module mPshBtnDbnce #(parameter pDbncePeriod=8191,pDbncerWidth=13)(
	input i_Clk,
	input i_PshBtn,
	output reg o_Dbnced);
	reg r_PshBtnIn_D1;
	reg r_PshBtnIn_D2;
	reg r_PshBtnIn_D3;
	reg [pDbncerWidth-1:0] rv_Dbncer;
	always@(posedge i_Clk)
		begin 
			r_PshBtnIn_D1 <= i_PshBtn;
			r_PshBtnIn_D2 <= r_PshBtnIn_D1;
		    r_PshBtnIn_D3 <= r_PshBtnIn_D2;
			if(r_PshBtnIn_D3^r_PshBtnIn_D2) rv_Dbncer <= pDbncePeriod;
			else begin 
				if(~(|rv_Dbncer)) rv_Dbncer<=rv_Dbncer-1;
				else o_Dbnced <= r_PshBtnIn_D3;
				end			
		end
endmodule