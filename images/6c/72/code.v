module top_module(
    input [3:0] D,        
    input CLK,            
    input CLR_n,          
    input LOAD_n,         
    input ENP,            
    input ENT,            
    output [3:0]Q,        
    output RCO            
);reg [3:0] counter;
	reg cout;
	
	always@(posedge CLK) begin
		if (CLR_n==1'b0) begin
			counter=4'b0000;
			cout = 1'b0;
		end
		else begin
			if(LOAD_n==1'b0) begin
				counter=D;
			end
			else if ((ENP == 1'b1) & (ENT == 1'b1))  begin
				if(counter==4'b1111) begin
					cout<=1'b1; 
					counter<=4'b0000;
				end
				else begin 
					counter<=counter+1; 
					cout<=1'b0; 
				end
			end
		end
	end
	
	assign Q = counter;
	assign RCO = cout;
	
endmodule