module top_module(PHI1, W4010, W4012, W4013, W4014, W4015, DataBus, CPU_Addr);input PHI1;
	input W4010;
	input W4012;
	input W4013;
	input W4014;
	input W4015;
	inout [7:0] DataBus;
	output [15:0] CPU_Addr;

	
	

	
	
	
	
	
	
	
	
	
	
	

	

	assign DataBus = ~PHI1 ? (W4014 ? 8'h2 : (W4010 ? 8'h0E : (W4012 ? 8'hC0 : (W4013 ? 8'hFF : (W4015 ? 8'h1F : 8'hzz))))) : 8'hzz;

	assign CPU_Addr = W4010 ? 16'h4010 : (W4012 ? 16'h4012 : (W4013 ? 16'h4013 : (W4014 ? 16'h4014 : (W4015 ? 16'h4015 : 16'h0))));endmodule