module top_module(	
  clk, clrn, load,	shift, datain,
	dataout	);parameter DATA_WIDTH = 8;
  
	input                  clk;
	input                  clrn;
	input                  load;
	input                  shift;
	input [DATA_WIDTH-1:0]  datain;
	output                 dataout;
	
	reg [DATA_WIDTH-1:0]   dataout_reg;
	
	always @ (posedge clk or negedge clrn) begin
		if(!clrn) 
			dataout_reg <= {DATA_WIDTH{1'b0}};
		
		else begin
			if(load) 
				dataout_reg <= datain;
			else 
				if(shift)
					dataout_reg <= {dataout_reg[0], dataout_reg[DATA_WIDTH-1:1]};
		end
	end
	
	assign dataout = dataout_reg[0];endmodule