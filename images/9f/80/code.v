module top_module(
	input [7:0]scan_code1,
	output [15:0]sound1,
	output sound_off1
);assign sound_off1=(scan_code1==8'hf0)?0:1;


	wire L_5_tr=(scan_code1==8'h1c)?1:0;
	wire L_6_tr=(scan_code1==8'h1b)?1:0;
	wire L_7_tr=(scan_code1==8'h23)?1:0;
	wire M_1_tr=(scan_code1==8'h2b)?1:0;
	wire M_2_tr=(scan_code1==8'h34)?1:0;
	wire M_3_tr=(scan_code1==8'h33)?1:0;
	wire M_4_tr=(scan_code1==8'h3b)?1:0;
	wire M_5_tr=(scan_code1==8'h42)?1:0;
	wire M_6_tr=(scan_code1==8'h4b)?1:0;
	wire M_7_tr=(scan_code1==8'h4c)?1:0;
	wire H_1_tr=(scan_code1==8'h52)?1:0;
	wire H_2_tr=0;
	wire H_3_tr=0;
	wire H_4_tr=0;
	wire H_5_tr=0;
	wire Hu4_tr=0;
	wire Hu2_tr=0;
	wire Hu1_tr=(scan_code1==8'h5b)?1:0;
	wire Mu6_tr=(scan_code1==8'h4d)?1:0;
	wire Mu5_tr=(scan_code1==8'h44)?1:0;
	wire Mu4_tr=(scan_code1==8'h43)?1:0;
	wire Mu2_tr=(scan_code1==8'h35)?1:0;
	wire Mu1_tr=(scan_code1==8'h2c)?1:0;
	wire Lu6_tr=(scan_code1==8'h24)?1:0;
	wire Lu5_tr=(scan_code1==8'h1d)?1:0;
	wire Lu4_tr=(scan_code1==8'h15)?1:0;

	assign sound1=(    
		(Lu4_tr)?400  :(
		(L_5_tr)?423  :(
		(Lu5_tr)?448  :(
		(L_6_tr)?475  :(
		(Lu6_tr)?503  :(
		(L_7_tr)?533  :(
		(M_1_tr)?565  :(
		(Mu1_tr)?599  :(
		(M_2_tr)?634  :(
		(Mu2_tr)?672  :(
		(M_3_tr)?712  :(
		(M_4_tr)?755  :(
		(Mu4_tr)?800  :(
		(M_5_tr)?847  :(
		(Mu5_tr)?897  :(
		(M_6_tr)?951  :(
		(Mu6_tr)?1007 :(
		(M_7_tr)?1067 :(
		(H_1_tr)?1131 :(
		(Hu1_tr)?1198 :1
		)))))))))))))))))))
	);

endmodule