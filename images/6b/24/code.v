module top_module( input clk0,
                            input clk1,
			                input clk2,
			                input clk3,
			                input resetn,
			                input wen0,
			                input wen1,
			                input wen2,
			                input [7:0] data0,
			                input [7:0] data1,
			                input [7:0] data2
			                );bit [12:0] clk;
bit reset_n;
bit [8:0] wen;
bit [7:0] i_data3, i_data4, i_data5;
bit freeze = 0;

always @(*)
begin
clk[10]  = clk0;
clk[3]  = clk1;
clk[4]  = clk2;
clk[5]  = clk3;
reset_n = resetn;
end

always @(*)
begin
wen[3]  = wen0;
i_data3 = data0;
end

always @(*)
begin
wen[4]  = wen1;
i_data4 = data1;
end

always @(*)
begin
wen[5]  = wen2;
i_data5 = data2;
end

endmodule