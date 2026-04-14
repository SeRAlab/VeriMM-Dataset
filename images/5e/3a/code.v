module top_module( 
	
	input wire memclk_i,
	output reg [23:0]	bus_A_o,
	output reg [7:0] bus_D_o,
	output reg [31:0] romflags_o,
	
	input busclk_i,	
	input nreset_i,
	input [3:0] A_i,	
	input [7:0] D_i,
	output reg [7:0] D_o,
	input nWR_i,
	input nRD_i	
	);reg [23:0] addr_io;
	
	
	
	
	
	
	
	
	
	function [7:0] lookup_register( input [3:0] a );
		case( a )
			4'h0: lookup_register = addr_io[7:0];
			4'h1: lookup_register = addr_io[15:8];
			4'h2: lookup_register = addr_io[23:16];
			4'h4: lookup_register = romflags_o[7:0];
			4'h5: lookup_register = romflags_o[15:8];
			4'h6: lookup_register = romflags_o[23:16];
			4'h7: lookup_register = romflags_o[31:24];
			default: lookup_register = 8'hff;
		endcase
	endfunction
	
	
	task write_register(
		input [3:0] a,
		input [7:0] d
	);		
		case( a )
			4'h0: addr_io[7:0] <= d;
			4'h1: addr_io[15:8] <= d;
			4'h2: addr_io[23:16] <= d;
			4'h4: romflags_o[d[4:0]] <= d[7];
			4'hf: bus_D_o <= d;
			default: ;
		endcase
	endtask
	
	
	always @(posedge busclk_i)
	begin
		if( !nreset_i ) begin
			addr_io <= 24'd0;
			bus_D_o <= 8'd0;
			romflags_o <= 32'd0;
		end
		else begin
			if( !nRD_i ) D_o <= lookup_register(A_i);
			if( !nWR_i ) begin
				write_register(A_i,D_i);
				if( A_i == 4'hf ) addr_io <= addr_io + 1'b1;
			end
		end
	end
	
	
	always @(posedge memclk_i)
	begin
		bus_A_o <= (addr_io -1'b1);	
	end
	
endmodule