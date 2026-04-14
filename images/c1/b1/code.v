module move_cell(
    input r,
    input b,
    input fw_in,
    input bw_in,
    output fw_out,
    output bw_out,
    input pulse,
    output r_out,
    output b_out
    );
reg r_out_reg;
reg b_out_reg;
always @( * ) begin
	if ( bw_in && fw_in ) begin
		b_out_reg = 1;
		r_out_reg = 0;
	end
	else begin
		b_out_reg = b;
		r_out_reg = r;
	end
end
assign 	fw_out = pulse || (r && fw_in);
assign	bw_out = bw_in || (b && fw_in);
assign 	r_out = r_out_reg;
assign	b_out = b_out_reg;
endmodule