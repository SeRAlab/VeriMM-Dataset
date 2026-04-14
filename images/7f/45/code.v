module top_module( 
		
		
 
 
							input  wire [3:0] cpu_d
							, input  wire cpu_rw
							, input  wire Ncpu_romsel
							, output wire hc161_out0
							, output wire hc161_out1
							, output wire hc161_out2
							, output wire hc161_out3
							);reg [3:0] hc161_krn; 
			
	
	assign hc161_out0 = hc161_krn [0:0];
	assign hc161_out1 = hc161_krn [1:1];
	assign hc161_out2 = hc161_krn [2:2];
	assign hc161_out3 = hc161_krn [3:3]; 
			
	
	always @(posedge Ncpu_romsel) 
			
	begin
		if (!cpu_rw) 
			
		begin
			hc161_krn <= cpu_d; 
		end
	end
	
endmodule