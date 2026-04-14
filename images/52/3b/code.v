module top_module(
	input r_req_store,
	input pte_a,
	input pte_d,

	output AD_bit_not_ok
	);assign AD_bit_not_ok = !pte_d && r_req_store || !pte_a;

endmodule