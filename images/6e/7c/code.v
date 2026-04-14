module top_module(
	input clk,reset,En,
	input [3:0] sel_reg,
	input [7:0] data_save,
	output reg [7:0] seg,min,hora,day,month,year,seg_t,min_t,hora_t
    );always @(posedge clk)
	begin
	if (reset)
		begin
		seg = 8'b00000000;
		min = 8'b00000000;
		hora = 8'b00000000;
		day = 8'b00000000;
		month = 8'b00000000;
		year = 8'b00000000;
		seg_t = 8'b00000000;
		min_t = 8'b00000000;
		hora_t = 8'b00000000;
		end
	else
	begin
		if(En)
		case (sel_reg)
			4'b0000: seg = data_save;
			4'b0001: min = data_save;
			4'b0010: hora = data_save;
			4'b0011: day = data_save;
			4'b0100: month = data_save;
			4'b0101: year = data_save;
			4'b0110: seg_t = data_save;
			4'b0111: min_t = data_save;
			4'b1000: hora_t = data_save;
			default: 
				begin
				seg = seg;
				min = min;
				hora = hora;
				day = day;
				month = month;
				year = year;
				seg_t = seg_t;
				min_t = min_t;
				hora_t = hora_t;
				end
		endcase
	end
end
	
endmodule