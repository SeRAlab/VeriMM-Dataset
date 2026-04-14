module top_module(
	     input[255:0]  mglehy,
	     input[215:0]  drricx,
	     input[15:0]   apqrli,
	     input[2:0]    szlfpf,
	     input[15:0]   dzosui,
	     input[31:0]   zndrba,
	     output wire [223:0] bxiouf
	     );wire [463:0] zhknfc  =   ({29{~apqrli}} & {mglehy, drricx[215:8]})
		| ({29{apqrli}}  & {mglehy[247:0], drricx});
   wire [335:0] umntwz =   ({21{~dzosui}} & zhknfc[463:128])
		| ({21{dzosui}}  & zhknfc[335:0]);
   wire [335:0] viuvoc = umntwz << {szlfpf, 4'b0000};
   wire [223:0] rzyeut = viuvoc[335:112];
   assign bxiouf       = {rzyeut[7:0],
             		  rzyeut[15:8],
             		  rzyeut[23:16],
             		  rzyeut[31:24],
             		  rzyeut[39:32],
             		  rzyeut[47:40],
             		  rzyeut[55:48],
             		  rzyeut[63:56],
             		  rzyeut[71:64],
             		  rzyeut[79:72],
             		  rzyeut[87:80],
             		  rzyeut[95:88],
             		  rzyeut[103:96],
             		  rzyeut[111:104],
             		  rzyeut[119:112],
             		  rzyeut[127:120],
             		  rzyeut[135:128],
             		  rzyeut[143:136],
             		  rzyeut[151:144],
             		  rzyeut[159:152],
             		  rzyeut[167:160],
             		  rzyeut[175:168],
             		  rzyeut[183:176],
             		  rzyeut[191:184],
             		  rzyeut[199:192],
             		  rzyeut[207:200],
             		  rzyeut[215:208],
             		  rzyeut[223:216]};

endmodule