module top_module(
	input clk_i,
	input reset_n,
	output reg [2:0] sel,
	output reg [6:0] segments
	);reg [1:0] state;
	reg [1:0] state_next;
	
	reg [3:0] num_int;  //Internal number storage
	
	parameter S0 = 2'b00;  //Disp Digit 1
	parameter S1 = 2'b01;  //Disp Digit 2
	parameter S2 = 2'b10;  //Disp Digit 3
	parameter S3 = 2'b11;  //Disp Digit 4
	
	//Async reset
	always @ (posedge clk_i, negedge reset_n)
		begin
			if(!reset_n)
				state <= S0;
			else
				state <= state_next;	
		end
	 
	//Next state logic
	always @ (*)
		begin
			case(state)
				S0: 	 state_next = S1;
				S1: 	 state_next = S2;
				S2: 	 state_next = S3;
				S3: 	 state_next = S0;
				default: state_next = S0;
			endcase
		end
	
	//"Determine #" Block
	always @ (*)
		begin
			case (state)
				S0:
				begin
					sel = 3'b000;  //Select Digit 1
					num_int = 0;
				end
				S1:
				begin
					sel = 3'b001;  //Select Digit 2
					num_int = 1;
				end
				S2:
				begin
					sel = 3'b011;  //Select Digit 3
					num_int = 2;
				end
				S3:
				begin
					sel = 3'b100;  //Select Digit 4
					num_int = 3;
				end
			endcase
		end
	
	//Display logic
	always @ (*)
		begin
			case (num_int)
				0: segments = 7'b1000000;  //Display 0
				1: segments = 7'b1111001;  //Display 1
				2: segments = 7'b0100100;  //Display 2
				3: segments = 7'b0110000;  //Display 3
				4: segments = 7'b0011001;  //Display 4
				5: segments = 7'b0010010;  //Display 5
				6: segments = 7'b0000010;  //Display 6
				7: segments = 7'b1111000;  //Display 7
				8: segments = 7'b0000000;  //Display 8
				9: segments = 7'b0010000;  //Display 9
				default: segments = 7'b1111111; //Turn off all segments
			endcase
		end
	
endmodule