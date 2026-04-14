module top_module(ACK_cpu, clk_cpu, rst_cpu, outDATA_cpu, outSEND_cpu);output reg outSEND_cpu;
  	output reg [31:0] outDATA_cpu;

	input ACK_cpu;
  	input clk_cpu, rst_cpu;

	
	reg currentState_cpu, nextState_cpu;

	
	always @ (posedge clk_cpu)
	begin
		if (rst_cpu == 1)
			currentState_cpu <= 0;
		else
			currentState_cpu <= nextState_cpu;
	end

	
	always @ (*)
	begin
		case ({currentState_cpu})
			0, 1:
				if (ACK_cpu == 0)
					nextState_cpu = 1;
				else
					nextState_cpu = 0;
		endcase
	end

	
	always @ (*)
	begin
		case ({currentState_cpu})
			0:
			begin
				outSEND_cpu = 0;
			end
			1:
			begin
				outSEND_cpu = 1;
				
				outDATA_cpu = $random;
			end

		endcase
	end

endmodule