module top_module(
	input [31:0] rt_out,
	input [1:0] mem_addr_in,
	input MemWrite,
	input [5:0] IR_out,
	output reg [31:0] rt_out_shift,
	output reg [3:0] mem_byte_write_out
);reg [3:0] mem_byte_write;

	always @ (*)
	begin
		case (IR_out)
			6'b101011: begin 
						rt_out_shift = rt_out;
						mem_byte_write = 4'b1111;
					  end
			default: begin
						case (mem_addr_in)
							2'b00: begin 
									rt_out_shift = {rt_out[7:0],  24'b0};
									mem_byte_write = 4'b1000;
								   end
							2'b01: begin 
									rt_out_shift = {rt_out[15:0], 16'b0};
									mem_byte_write = 4'b1100;
								   end
							2'b10: begin 
									rt_out_shift = {rt_out[23:0], 8'b0};
									mem_byte_write = 4'b1110;
								   end
							2'b11: begin 
									rt_out_shift = rt_out;
									mem_byte_write = 4'b1111;
								   end
						endcase
					  end
		endcase
		mem_byte_write_out = mem_byte_write & {4{MemWrite}};
	end

endmodule