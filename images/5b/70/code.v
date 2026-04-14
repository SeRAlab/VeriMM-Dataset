module top_module(

	a15,a14, 

	mreq_n, 
	rd_n,   
	wr_n,   

	mema14,mema15, 
	mema16,mema17, 
	mema18,mema21, 

	ram0cs_n, 
	ram1cs_n, 
	ram2cs_n, 
	ram3cs_n, 

	romcs_n, 

	memoe_n, 
	memwe_n, 

	mode_ramro, 
	mode_norom, 
	mode_pg0,   
	mode_pg1,   
	mode_pg2,   
	mode_pg3    
);input a15,a14;

	input mreq_n,rd_n,wr_n;

	output reg mema14, mema15, mema16, mema17, mema18, mema21;

	output reg ram0cs_n,ram1cs_n,ram2cs_n,ram3cs_n;

	output reg romcs_n;

	output reg memoe_n,memwe_n;

	input mode_ramro,mode_norom;
	input [7:0] mode_pg0,mode_pg1,mode_pg2,mode_pg3;




	reg [7:0] high_addr;





	always @*
	begin
        case( {a15,a14} )
			2'b00: 
				high_addr <= mode_pg0;
			2'b01: 
				high_addr <= mode_pg1;
			2'b10: 
				high_addr <= mode_pg2;
			2'b11: 
				high_addr <= mode_pg3;
        endcase
	end




	always @*
	begin
		{ mema21, mema18, mema17, mema16, mema15, mema14 } <= { high_addr[7], high_addr[4:0] };
	end




	always @*
	begin
		if( (mode_norom==1'b0) && ( {a15,a14}!=2'b01 ) ) 
		begin
			romcs_n <= 1'b0;

			ram0cs_n <= 1'b1;
			ram1cs_n <= 1'b1;
			ram2cs_n <= 1'b1;
			ram3cs_n <= 1'b1;
		end
		else 
		begin
			romcs_n <= 1'b1;

			ram0cs_n <= ( high_addr[6:5]==2'b00 ) ? 1'b0 : 1'b1;
			ram1cs_n <= ( high_addr[6:5]==2'b01 ) ? 1'b0 : 1'b1;
			ram2cs_n <= ( high_addr[6:5]==2'b10 ) ? 1'b0 : 1'b1;
			ram3cs_n <= ( high_addr[6:5]==2'b11 ) ? 1'b0 : 1'b1;
		end
	end




	always @*
	begin
		memoe_n <= mreq_n | rd_n;

		if( (high_addr[6:1] == 6'd0) && (mode_ramro==1'b1) && (mode_norom==1'b1) ) 
			memwe_n <= 1'b1;
		else 
			memwe_n <= mreq_n | wr_n;
	end

endmodule