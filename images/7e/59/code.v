module top_module(
	input wire clk,
	input wire [15:0] a,  
	input wire wr,
	input wire vramdec,     
	input wire [17:0] cnt,  
	input wire [7:0] DinShiftR,  
	input wire videoinverso,      
	output wire cpuwait,    
	output wire [9:0] ASRAMVideo,  
	output wire [2:0] ACRAMVideo,  
	output wire sramce,     
	output wire cramce,     
	output wire scramoe,    
	output wire scramwr,    
	output wire video       
	);wire vhold;
	wire viden;
	wire shld;
	reg ffvideoi;     
	reg envramab;    
	reg [7:0] shiftreg;

	assign viden = ~(cnt[16] & cnt[15]) & (~(cnt[17] | cnt[8]));
	assign vhold = ~(a[10] & viden);
	assign cpuwait = vhold | vramdec;

	
	always @(posedge clk)
		if (vhold)
			envramab <= vramdec;
		else
			envramab <= vramdec | envramab;

	assign cramce = ~(a[11] | envramab);
	assign sramce = ~(envramab | cramce);
	assign scramwr = envramab | wr;
	assign scramoe = ~scramwr;

	assign ASRAMVideo = {cnt[16:12],cnt[7:3]};
	assign ACRAMVideo = cnt[11:9];
	
	always @(posedge clk)
		if (&cnt[2:0])
			ffvideoi <= (videoinverso & viden);

	assign shld = ~(&cnt[2:0] & viden);
	
	always @(posedge clk)
		if (shld)
			shiftreg <= shiftreg<<1;
		else
			shiftreg <= DinShiftR;
	
	assign video = (shiftreg[7] ^ ffvideoi);
endmodule