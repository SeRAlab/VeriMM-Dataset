module thread_ring
	#(
	parameter	integer							THREADS			= 8,	
	parameter	integer							THRD_W			= 3	
	)
	(
	input			wire								clk_i,  
	input			wire								rst_i,  
	output		wire	[THRD_W-1:0]			thrd_0_o,
	output		wire	[THRD_W-1:0]			thrd_1_o,
	output		wire	[THRD_W-1:0]			thrd_2_o,
	output		wire	[THRD_W-1:0]			thrd_3_o,
	output		wire	[THRD_W-1:0]			thrd_4_o,
	output		wire	[THRD_W-1:0]			thrd_5_o,
	output		wire	[THRD_W-1:0]			thrd_6_o,
	output		wire	[THRD_W-1:0]			thrd_7_o
	);
	reg					[THRD_W-1:0]			thrd[0:THREADS-1];
	localparam			[THRD_W-1:0]			THRD_OS = 'd5;
	integer j;
	always @ ( posedge clk_i or posedge rst_i ) begin
		if ( rst_i ) begin
			for ( j = 0; j < THREADS; j = j + 1 ) begin 
				thrd[j] <= THRD_OS - j[THRD_W-1:0];
			end
		end else begin
			for ( j = 0; j < THREADS; j = j + 1 ) begin 
				if ( j == 0 ) thrd[j] <= thrd[j] + 1'b1;  
				else thrd[j] <= thrd[j-1];
			end
		end
	end
	assign thrd_0_o = thrd[0];
	assign thrd_1_o = thrd[1];
	assign thrd_2_o = thrd[2];
	assign thrd_3_o = thrd[3];
	assign thrd_4_o = thrd[4];
	assign thrd_5_o = thrd[5];
	assign thrd_6_o = thrd[6];
	assign thrd_7_o = thrd[7];
endmodule