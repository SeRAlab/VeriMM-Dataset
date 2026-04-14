module top_module(
	input clk_4f_c,
	input valid_in,
	input [31:0] Data_in,
	output reg valid_out_c,
	output reg [7:0] Data_out_c
);reg [1:0] contador;

	always @(posedge clk_4f_c) begin
		if (valid_in) begin
			if (contador >= 0) begin
				case (contador)
					2'b00: 
					begin
						Data_out_c <= Data_in[31:24];
						contador <= contador + 1;
						valid_out_c <= 1;
					end  
					2'b01: 
					begin
						Data_out_c <= Data_in[23:16];
						contador <= contador + 1;
						valid_out_c <= 1;
					end  
					2'b10:
					begin
						Data_out_c <= Data_in[15:8];
						contador <= contador + 1;
						valid_out_c <= 1;
					end  
					2'b11:
					begin
						Data_out_c <= Data_in[7:0];
						contador <= 2'b0;
						valid_out_c <= 1;
					end 
				endcase
			end
		end
		else begin
			contador <= 2'b0;
			valid_out_c <= 0;
			Data_out_c <= 32'b0;
		end
	end
endmodule