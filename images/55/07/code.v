module top_module(
	sysclk,
	sync_n,
	data_in,
	data_in_valid,
	data_out,
	data_out_valid
);input	sysclk;
input	sync_n;
input	[7:0] data_in;
input	data_in_valid;
output	[31:0] data_out;
reg		[31:0] data_out;
output	data_out_valid;
reg		data_out_valid;

reg		[1:0] Data_count;
reg		[23:0] D_reg;
wire	Sh_enable;
wire	packeq;

assign	Sh_enable = data_in_valid;
assign	packeq = (Data_count == 2'b11);

always@(posedge sysclk)
begin
	casex({sync_n,Sh_enable,packeq})
	3'b0xx:
		begin
			Data_count <= 0;
			data_out_valid <= 0;
			data_out <= data_out;
			D_reg <= 0;
		end
	3'b10x:
		begin
			Data_count <= Data_count;
			data_out_valid <= 0;
			data_out <= data_out;
			D_reg <= D_reg;
		end
	3'b110:
		begin
			Data_count <= Data_count + 1'b1;
			data_out_valid <= 0;
			data_out <= data_out;
			D_reg <= {D_reg[15:0],data_in};
		end
	3'b111:
		begin
			Data_count <= 0;
			data_out_valid <= 1;
			data_out <= {D_reg,data_in};
			D_reg <= {D_reg[15:0],data_in};
		end
	endcase
end

endmodule