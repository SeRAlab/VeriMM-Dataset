module top_module(

		input										Reset,
		input 									Clk,
		input					[31:0]		MemAddr,

		output	wire		[31:0]		MemDataOut
    );reg				[31:0]		Memory[0:63];
		reg 			[5:0]			Addr;

	assign		MemDataOut	=	Memory[Addr];

	always @ ( posedge Reset or posedge Clk )
		begin
			if ( Reset )
				begin
					Memory[0]			<=		{6'd8, 5'd29, 5'd29, -16'd8};              
					Memory[1]			<=		{6'd0, 5'd4, 5'd5, 5'd8, 5'd0, 6'd42};     
					Memory[2]			<=		{6'd43, 5'd29, 5'd31, 16'd4};              
					Memory[3]			<=		{6'd43, 5'd29, 5'd4, 16'd0};               
					Memory[4]      <=    {6'd4, 5'd8, 5'd0, 16'd3};                 
					Memory[5]      <=    {6'd8, 5'd0, 5'd2, 16'd0};                 
					Memory[6]      <=    {6'd8, 5'd29, 5'd29, 16'd8};               
					Memory[7]      <=    {6'd0, 5'd31, 5'd0, 5'd0, 5'd0, 6'd8};     
					
					Memory[8]      <=    {6'd8, 5'd4, 5'd4, -16'd1};                
					Memory[9]      <=    {6'd3, 26'd0};                             
					Memory[10]     <=    {6'd35, 5'd29, 5'd4, 16'd0};               
					Memory[11]     <=    {6'd35, 5'd29, 5'd31, 16'd4};              
					Memory[12]     <=    {6'd8, 5'd29, 5'd29, 16'd8};               
					Memory[13]     <=    {6'd0, 5'd4, 5'd2, 5'd2, 5'd0, 6'd32};     
					Memory[14]     <=    {6'd0, 5'd31, 5'd0, 5'd0, 5'd0, 6'd8};     
				end
			else
				Addr	<=		MemAddr[7:2];
		end

endmodule