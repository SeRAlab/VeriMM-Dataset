module top_module(assignment,clause_type,clause_mask,na_out);parameter size=1;

input assignment;
input clause_type;
input clause_mask;
output na_out;
	
	assign na_out=~(~(assignment^clause_type)&&clause_mask);

endmodule