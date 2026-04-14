module top_module(
	
	
	
	
	input [31:0] mem_data_out,
	input	[1:0] mem_addr_in,
	input [5:0] IR_out,
	output reg [31:0] mem_data_shift,
	output reg [3:0] Rd_write_byte_en
);always @ (*)
begin
	if (IR_out == 6'b100011)begin
		mem_data_shift = mem_data_out;
		Rd_write_byte_en=4'b1111;
	end
	else begin
		case (mem_addr_in)
			2'b00: begin mem_data_shift = mem_data_out; Rd_write_byte_en=4'b1111;end
			2'b01: begin mem_data_shift = {mem_data_out[23:0], 8'b0};Rd_write_byte_en=4'b1110; end
			2'b10: begin mem_data_shift = {mem_data_out[15:0], 16'b0};Rd_write_byte_en=4'b1100; end
			2'b11: begin mem_data_shift = {mem_data_out[7:0],  24'b0};Rd_write_byte_en=4'b1000; end
		endcase
	end
end

endmodule