module stacks_mux
	#(
	parameter	integer							DATA_W			= 32,		
	parameter	integer							ADDR_W			= 16,		
	parameter	integer							IM_W				= 8,		
	parameter	integer							STK_W				= 3		
	)
	(
	input			wire								clk_i,						
	input			wire								rst_i,						
	input			wire	[STK_W-1:0]				data_sel_a_i,				
	input			wire	[STK_W-1:0]				data_sel_b_i,				
	input			wire	[STK_W-1:0]				addr_sel_b_i,				
	input			wire								imda_i,						
	input			wire								imad_i,						
	input			wire	[DATA_W-1:0]			pop_data0_i,				
	input			wire	[DATA_W-1:0]			pop_data1_i,				
	input			wire	[DATA_W-1:0]			pop_data2_i,				
	input			wire	[DATA_W-1:0]			pop_data3_i,				
	input			wire	[DATA_W-1:0]			pop_data4_i,				
	input			wire	[DATA_W-1:0]			pop_data5_i,				
	input			wire	[DATA_W-1:0]			pop_data6_i,				
	input			wire	[DATA_W-1:0]			pop_data7_i,				
	input			wire	[IM_W-1:0]				im_i,							
	output		wire	[DATA_W-1:0]			a_data_o,					
	output		wire	[DATA_W-1:0]			b_data_o,
	output		wire	[ADDR_W-1:0]			b_addr_o
	);
	reg					[DATA_W-1:0]			a_data, b_data;
	reg					[ADDR_W-1:0]			b_addr;
	always @ ( * ) begin
		case ( data_sel_a_i )
			'd0 : a_data <= pop_data0_i;
			'd1 : a_data <= pop_data1_i;
			'd2 : a_data <= pop_data2_i;
			'd3 : a_data <= pop_data3_i;
			'd4 : a_data <= pop_data4_i;
			'd5 : a_data <= pop_data5_i;
			'd6 : a_data <= pop_data6_i;
			'd7 : a_data <= pop_data7_i;
		endcase
	end
	always @ ( * ) begin
		case ( data_sel_b_i )
			'd0 : b_data <= pop_data0_i;
			'd1 : b_data <= pop_data1_i;
			'd2 : b_data <= pop_data2_i;
			'd3 : b_data <= pop_data3_i;
			'd4 : b_data <= pop_data4_i;
			'd5 : b_data <= pop_data5_i;
			'd6 : b_data <= pop_data6_i;
			'd7 : b_data <= pop_data7_i;
		endcase
	end
	always @ ( * ) begin
		case ( addr_sel_b_i )
			'd0 : b_addr <= pop_data0_i[ADDR_W-1:0];
			'd1 : b_addr <= pop_data1_i[ADDR_W-1:0];
			'd2 : b_addr <= pop_data2_i[ADDR_W-1:0];
			'd3 : b_addr <= pop_data3_i[ADDR_W-1:0];
			'd4 : b_addr <= pop_data4_i[ADDR_W-1:0];
			'd5 : b_addr <= pop_data5_i[ADDR_W-1:0];
			'd6 : b_addr <= pop_data6_i[ADDR_W-1:0];
			'd7 : b_addr <= pop_data7_i[ADDR_W-1:0];
		endcase
	end
	assign a_data_o = a_data;
	assign b_data_o = ( imda_i ) ? $signed( im_i ) : $signed( b_data );
	assign b_addr_o = ( imad_i ) ? $signed( im_i ) : $signed( b_addr );
endmodule