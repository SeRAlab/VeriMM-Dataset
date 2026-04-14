module top_module(reset,clk1ms,PWM,nextState,state,counter);input reset,clk1ms;
output reg [25:0] counter;

output reg PWM;
output reg [1:0] nextState,state;


parameter start= 2'b00, OFF= 2'b01, ON= 2'b10;
parameter c2 = 5'd2, c18 = 5'd18;

always@(posedge clk1ms or posedge reset)
begin 
	if (reset)
		state <= start;
	else 
		state <= nextState;
end 

always@(state or counter)
begin 
	case(state)
	  
	  start:begin
					counter = 0;
					nextState = OFF;
				end 
	  
	  	OFF: 
	  	  
	 begin
			if (counter == 18) 
					begin
					counter = 0;
					nextState = ON;
					end 
				
			else
					begin
					counter <= #1 counter + 1;
					nextState = OFF;
					end 
  end
	
	ON:
	   begin 
			if (counter == 2)
					nextState = start; 
			else 
				  counter <= #1 counter + 1'd1;
					nextState = ON; 
		end 
 
	default :
					nextState = start;
endcase
end 		

always@(state)
case (state)
	start: 	PWM = 0;
	OFF: 		PWM = 0;
	ON: 		PWM = 1;
	 
	default : PWM =0;
endcase


endmodule