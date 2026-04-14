module top_module(clk,rst,kd,kc,kbs,data,parity_error);input clk,rst,kd,kc;
	output kbs;
	output reg parity_error = 1'b0;
	output reg [7:0]data;
	reg [7:0] data_next;
	reg [10:2]shift;
	reg [10:2]shift_next;
	reg [3:0] data_in_counter = 4'd0;
	reg [3:0] data_in_counter_next;
	
	reg [1:0]kd_s = 2'b00;
	reg [1:0]kc_s = 2'b00;
	reg reset_data_in_counter;
	reg new_data_available = 1'b0;
	reg new_data_available_next;
	
	wire kc_ne;
	assign kbs=new_data_available;

	
	always@(posedge clk)
		if(rst)
			{kd_s,kc_s} <= 4'b0;
		else
		begin
			kd_s <= {kd_s[0], kd};
			kc_s <= {kc_s[0], kc};
		end
		
	
	assign kc_ne = (~kc_s[0]) & (kc_s[1]);
	
	
	always@(*)
		case ({rst,kc_ne})
			2'b00:shift_next = shift;
			2'b01:shift_next = {kd_s[1], shift[10:3]};
			default:shift_next = 11'd0;
		endcase

	always@(posedge clk)
		shift <= shift_next;
	
	always @(*)
		if(data_in_counter == 4'd11)
			reset_data_in_counter = 1'b1;
		else
			reset_data_in_counter=rst;

	
	
	always@(*)
		case({reset_data_in_counter,kc_ne})
			2'b00: data_in_counter_next = data_in_counter;
			2'b01: data_in_counter_next = data_in_counter + 4'd1;
			default:data_in_counter_next = 4'd0;
		endcase
		
	always@(posedge clk)
		data_in_counter <= data_in_counter_next;
			
	
	reg parity_error_next;
	always@(*)
		if((data_in_counter == 4'd10) && (!parity_error_next))
			new_data_available_next = 1'b1;
		else
			new_data_available_next = 1'b0;
	
	always@(posedge clk)
		new_data_available <= new_data_available_next;
	
	
	always@(*)
		if(data_in_counter == 4'd9)
			data_next = shift[10:3];
		else
			data_next = data;
	
	always@(posedge clk)
		data <= data_next;

	
	
	wire parity_local;

	assign parity_local = (^shift[10:2]);
	
	always@(*)
		if(data_in_counter == 4'd10)
			if(parity_local == 1'b1)
				parity_error_next = 1'b0;
			else
				parity_error_next = 1'b1;
		else
			parity_error_next = parity_error;
	
	always@(posedge clk or posedge rst)
		if(rst)
			parity_error <= 1'b0;
		else
			parity_error<=parity_error_next;
	
endmodule