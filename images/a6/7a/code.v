module top_module(hab_escrita, reset, clock, e1, e2,entrada_e1, entrada_e2);output reg [15:0] e1, e2;
  input [15:0] entrada_e1, entrada_e2;
  input reset, clock, hab_escrita;
  reg [15:0] registro [1:0];	
	

	always @(posedge clock) begin 		  
		if(reset) begin 
			registro[0] = 16'b0000000000000000;
			registro[1] = 16'b0000000000000000;
				
		end	else if(hab_escrita) begin 
			registro[0] = entrada_e1; 
			registro[1] = entrada_e2; 
				
		end 
			
		if(registro[0]<registro[1]) begin
			e1 = registro[1]; 
			e2 = registro[0]; 
		end	else begin
			e1 = registro[0]; 
			e2 = registro[1]; 
		end
	end
endmodule