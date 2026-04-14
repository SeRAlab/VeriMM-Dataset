module top_module(
			reg_input,
			Clk,
			AC_data,
			reg_load,
			Z_Flag
    );input [15:0] reg_input;
input Clk;
output reg [15:0] AC_data;
output reg Z_Flag;
input reg_load;

always @(posedge Clk)
		begin
			if (reg_load)
				begin
					AC_data <=reg_input;
				end
			if(AC_data == 0)
				begin
					Z_Flag <= 1'b1;
				end
			else
				begin
					Z_Flag <= 1'b0;
				end
		end


endmodule