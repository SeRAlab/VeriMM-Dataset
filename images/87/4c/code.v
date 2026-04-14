module top_module( clock, enable, rd_adrs, ra_adrs, rb_adrs, wr_en, data_in, ra_out, rb_out);input clock;
input enable;
input wr_en;
input[2:0] rd_adrs;
input[2:0] ra_adrs;
input[2:0] rb_adrs;
input[15:0] data_in;
output[15:0] ra_out;
output[15:0] rb_out;

reg[15:0] ra_out = 0;
reg[15:0] rb_out = 0;


reg[15:0] internal_reg[0:7];


always@(posedge clock)
begin
	if(enable)
	begin
		if(wr_en)
		begin
		 internal_reg[rd_adrs][15:0] <= data_in;
		end
		else
		begin
		 ra_out <= internal_reg[ra_adrs][15:0];
		 rb_out <= internal_reg[rb_adrs][15:0];
		end
	end

end

endmodule