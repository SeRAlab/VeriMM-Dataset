module top_module(clk,RAMio,dBUSio,ctrl,enable,clr);input clk,clr,enable;
	input [1:0] ctrl;
	inout [15:0] dBUSio;
	inout [15:0] RAMio;
	reg [15:0] data;
	
	always @(posedge(clk))
	begin
		if(clr) begin data <= 16'd0; end
		else
			case({enable,ctrl})
			3'b100 : begin
				data <= dBUSio;
				end
			3'b101 : begin
				data <= RAMio;
				end
			default: begin 
				data <= data;
				end
			endcase
	end

	
	assign dBUSio = (enable && (ctrl==2)) ? data : 16'hZZ;
	assign RAMio = (enable && (ctrl==3)) ? data : 16'hZZ;
	
endmodule