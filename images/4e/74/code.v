module top_module(

	input  wire        clk, 


	input  wire        cend,     
	input  wire        pre_cend, 

	input  wire        vpix, 

	input  wire        fetch_start, 
	input  wire        fetch_end,   

	output reg         fetch_sync,     


	input  wire [15:0] video_data,   
	input  wire        video_strobe, 
	output reg         video_go, 

	output reg  [63:0] pic_bits 

	
	


);reg [3:0] fetch_sync_ctr; 
	                          
	                          

	reg [1:0] fetch_ptr; 
	reg       fetch_ptr_clr; 


	reg [15:0] fetch_data [0:3]; 

	
	always @(posedge clk)
		if( fetch_start && vpix )
			video_go <= 1'b1;
		else if( fetch_end )
			video_go <= 1'b0;



	
	always @(posedge clk) if( cend )
	begin
		if( fetch_start )
			fetch_sync_ctr <= 0;
		else
			fetch_sync_ctr <= fetch_sync_ctr + 1;
	end


	
	always @(posedge clk)
		if( (fetch_sync_ctr==1) && pre_cend )
			fetch_sync <= 1'b1;
		else
			fetch_sync <= 1'b0;



	
	always @(posedge clk)
		if( (fetch_sync_ctr==0) && pre_cend )
			fetch_ptr_clr <= 1'b1;
		else
			fetch_ptr_clr <= 1'b0;


	
	always @(posedge clk)
		if( fetch_ptr_clr )
			fetch_ptr <= 0;
		else if( video_strobe )
			fetch_ptr <= fetch_ptr + 1;



	
	always @(posedge clk) if( video_strobe )
		fetch_data[fetch_ptr] <= video_data;


	
	always @(posedge clk) if( fetch_sync )
	begin
		pic_bits[ 7:0 ] <= fetch_data[0][15:8 ];
		pic_bits[15:8 ] <= fetch_data[0][ 7:0 ];
		pic_bits[23:16] <= fetch_data[1][15:8 ];
		pic_bits[31:24] <= fetch_data[1][ 7:0 ];
		pic_bits[39:32] <= fetch_data[2][15:8 ];
		pic_bits[47:40] <= fetch_data[2][ 7:0 ];
		pic_bits[55:48] <= fetch_data[3][15:8 ];
		pic_bits[63:56] <= fetch_data[3][ 7:0 ];
	end

endmodule