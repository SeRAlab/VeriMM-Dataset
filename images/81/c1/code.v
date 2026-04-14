module top_module(
    input RxD_ser,
	 output CTS, 
	 input sys_clk,
	 input Baud16Tick, 
    output reg [7:0] TxD_par, 
    output TxD_ready
    );reg [1:0] RxD_sync;
	always @(posedge sys_clk) if(Baud16Tick) RxD_sync <= {RxD_sync[0], RxD_ser};
	
	
	
	reg [2:0] RxD_cnt=7;
	reg RxD_bit;

	always @(posedge sys_clk)
	if(Baud16Tick)
	begin
		if(RxD_sync[1] && RxD_cnt!=3'b111) RxD_cnt <= RxD_cnt + 1; 
		else if(~RxD_sync[1] && RxD_cnt!=3'b000) RxD_cnt <= RxD_cnt - 1; 
		
		
		if(RxD_cnt==3'b000) RxD_bit <= 0;
		else if(RxD_cnt==3'b111) RxD_bit <= 1;
	end
	
	
	reg [3:0] state=0;

	always @(posedge sys_clk)
	if(Baud16Tick)
	case(state)
		4'b0000: if(~RxD_bit) state <= 4'b1000; 
		4'b1000: if(next_bit) state <= 4'b1001; 
		4'b1001: if(next_bit) state <= 4'b1010; 
		4'b1010: if(next_bit) state <= 4'b1011; 
		4'b1011: if(next_bit) state <= 4'b1100; 
		4'b1100: if(next_bit) state <= 4'b1101; 
		4'b1101: if(next_bit) state <= 4'b1110; 
		4'b1110: if(next_bit) state <= 4'b1111; 
		4'b1111: if(next_bit) state <= 4'b0001; 
		4'b0001: if(next_bit) state <= 4'b0000; 
		default: state <= 4'b0000;
	endcase
	
	
	assign CTS = (state<2); 
	
	
	reg [3:0] bit_spacing;
	always @(posedge sys_clk)
	if(state==0)
		bit_spacing <= 0;
	else
	if(Baud16Tick) bit_spacing <= bit_spacing + 1;
	
	wire next_bit = (bit_spacing==15);
	
	assign TxD_ready = (state==1);
	
	
	
	always @(posedge sys_clk) if(Baud16Tick && next_bit && state[3]) TxD_par <= {RxD_bit, TxD_par[7:1]};
	
	
endmodule