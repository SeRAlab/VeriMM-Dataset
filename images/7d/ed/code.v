module top_module(clk, rst, data_in, letter_in);parameter letter_size = 8; 
	parameter word_length = 128;	
	parameter word_num	  = 63;		
	
	
	parameter START		= 4'b0000;
	parameter IDLE 		= 4'b0001; 
	parameter COMBINE	= 4'b0010;
	
	input clk;
	input rst;	
	input data_in;		
	
	input [letter_size-1:0] letter_in;		
	


	
	reg [word_length-1:0] mem_word [word_num-1:0];		
	reg [5:0] row_pt;			
	reg [7:0] col_pt;			
	reg [6:0] i;				
	
	reg [3:0] current_state;
	reg [3:0] next_state; 
	

	





	
	always@(posedge clk or negedge rst)	
		if(!rst)
			current_state <= START;
		else
			current_state <= next_state;
			
	always@*	  
		begin
			case(current_state)	
				START:	begin  
					if(data_in == 1)	next_state = COMBINE;
					else	next_state = START;
					end
				IDLE:	begin  
					if(data_in == 1)	next_state = COMBINE;
					else	next_state = IDLE;	
					end	
				COMBINE: begin 
					if(data_in == 0)	next_state = IDLE;
					else	next_state = COMBINE;
					end
				default: begin	
					next_state = START;
					end
			endcase
		end	  
		
	always@(posedge clk)
		case(current_state)
			START: begin 
				row_pt <= 0;
				col_pt <= 0;	  
				
				for(i=0; i<=63; i=i+1)
					mem_word[i] <= 128'b0; 
			end
			IDLE: begin
			end	  
			COMBINE: begin	  
				if( (letter_in==8'h00)&&(col_pt==0)) begin
					row_pt <= row_pt;	
				end
				else if ( (letter_in==8'h00)&&(col_pt!=0) ) begin	 
					
					row_pt <= row_pt + 1; 
					col_pt <= 0;
				end	
				else if (col_pt == 128) begin
					row_pt <= row_pt + 1;
					col_pt <= 0;
				end
				else if(data_in == 1) begin
					mem_word[row_pt] <= mem_word[row_pt] + (letter_in<<col_pt);	  
					col_pt <= col_pt + 8;
				end
				else begin
				end
			end
			default: begin
			end
		endcase
	
	
	
	
	
	
	
	
	
endmodule