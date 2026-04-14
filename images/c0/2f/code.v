module int_encoder # (
		parameter VECTOR_INT_TABLE_SIZE = 0,
		parameter STORE_INTERUPTS = "FALSE"
		)(
		input rst,
		input [((VECTOR_INT_TABLE_SIZE == 0) ? 0 : VECTOR_INT_TABLE_SIZE-1):0]int_sig_in,
		output int_request,
		output reg[((VECTOR_INT_TABLE_SIZE > 127) ? 7 :
					(VECTOR_INT_TABLE_SIZE > 63) ? 6 :
					(VECTOR_INT_TABLE_SIZE > 31) ? 5 :
					(VECTOR_INT_TABLE_SIZE > 15) ? 4 :
					(VECTOR_INT_TABLE_SIZE > 7) ? 3 :
					(VECTOR_INT_TABLE_SIZE > 3) ? 2 :
					(VECTOR_INT_TABLE_SIZE > 1) ? 1 : 0) : 0]int_vect,
		input executed
		);
reg [VECTOR_INT_TABLE_SIZE : 0]int_sig_in_int;
reg [VECTOR_INT_TABLE_SIZE : 0]int_sig_in_int_n;
wire [VECTOR_INT_TABLE_SIZE : 0]int_sig_in_int_active = int_sig_in_int ^ int_sig_in_int_n;
genvar i;
generate
for (i = 0; i < VECTOR_INT_TABLE_SIZE;i = i + 1) 
begin :int_sig_store
always @(posedge rst or posedge int_sig_in[i])
begin
	if(STORE_INTERUPTS == "TRUE" && VECTOR_INT_TABLE_SIZE != 0)
	begin
		if(rst)
			int_sig_in_int[i] <= 1'b0;
		else
		begin
			if(int_sig_in_int_n[i] == int_sig_in_int[i])
				int_sig_in_int[i] <= ~int_sig_in_int_n[i];
		end
	end
end
always @ (posedge rst or posedge executed)
begin
	if(STORE_INTERUPTS == "TRUE" && VECTOR_INT_TABLE_SIZE != 0)
	begin
		if(rst)
			int_sig_in_int_n[i] <= 1'b0;
		else if(executed && int_vect == i)
			int_sig_in_int_n[int_vect] <= int_sig_in_int[int_vect];
	end
end
end
endgenerate
integer j;
always @*
begin
	if(VECTOR_INT_TABLE_SIZE != 0)
	begin
		int_vect <= 0;
		for (j=VECTOR_INT_TABLE_SIZE-1; j>=0; j=j-1)
		if ((STORE_INTERUPTS == "TRUE") ? int_sig_in_int_active[j] : int_sig_in[j]) 
			int_vect <= j+1;
	end
end
assign int_request = (int_vect != 0 && VECTOR_INT_TABLE_SIZE != 'h0);
endmodule