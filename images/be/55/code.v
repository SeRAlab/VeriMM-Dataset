module top_module(activecolumn,activegroup,load,lData_0,lData_1,lData_2,lData_3,lData_4,lData_5,lData_6,lData_7,data,CLK);parameter datawidth = 16;

	input wire CLK;

	input wire load;
	input wire activecolumn;
	input wire activegroup;
	
	input wire [datawidth-1:0] lData_0;
	input wire [datawidth-1:0] lData_1;
	input wire [datawidth-1:0] lData_2;
	input wire [datawidth-1:0] lData_3;
	input wire [datawidth-1:0] lData_4;
	input wire [datawidth-1:0] lData_5;
	input wire [datawidth-1:0] lData_6;
	input wire [datawidth-1:0] lData_7;

	output reg [datawidth-1:0] data;
	reg [datawidth-1:0] data_1;
	reg [datawidth-1:0] data_2;
	reg [datawidth-1:0] data_3;	
	reg [datawidth-1:0] data_4;
	reg [datawidth-1:0] data_5;
	reg [datawidth-1:0] data_6;
	reg [datawidth-1:0] data_7;

	reg [datawidth-1:0] slice_data_0;
	reg [datawidth-1:0] slice_data_1;
	reg [datawidth-1:0] slice_data_2;
	reg [datawidth-1:0] slice_data_3;
	reg [datawidth-1:0] slice_data_4;
	reg [datawidth-1:0] slice_data_5;
	reg [datawidth-1:0] slice_data_6;
	reg [datawidth-1:0] slice_data_7;
	
	always@(posedge CLK) 
	begin
		
		
		if (load == 1'b1) 
		begin
			slice_data_0 <= lData_0;
			slice_data_1 <= lData_1;
			slice_data_2 <= lData_2;
			slice_data_3 <= lData_3;
			slice_data_4 <= lData_4;
			slice_data_5 <= lData_5;
			slice_data_6 <= lData_6;
			slice_data_7 <= lData_7;
		end

		if (activegroup == 1'b0) 
		begin
			data <= slice_data_0;
			data_1 <= slice_data_1;
			data_2 <= slice_data_2;
			data_3 <= slice_data_3;
			data_4 <= slice_data_4;
			data_5 <= slice_data_5;
			data_6 <= slice_data_6;
			data_7 <= slice_data_7;
		end else if (activecolumn == 1'b1)
		begin
			data <= data_1;
			data_1 <= data_2;
			data_2 <= data_3;
			data_3 <= data_4;
			data_4 <= data_5;
			data_5 <= data_6;
			data_6 <= data_7;
			data_7 <= 16'b0;
		end else 
		begin
			data <= data;
			data_1 <= data_1;
			data_2 <= data_2;
			data_3 <= data_3;
			data_4 <= data_4;
			data_5 <= data_5;
			data_6 <= data_6;
			data_7 <= data_7;
		end

	end		
			
endmodule