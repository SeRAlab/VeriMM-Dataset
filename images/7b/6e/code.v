module top_module(

mask_id
);output [3:0] mask_id;

parameter [9:1] id3_m = 9'b0;
parameter [9:1] id2_m = 9'b0;
parameter [9:1] id1_m = 9'b0;
parameter [9:1] id0_m = 9'b0;


assign 	   mask_id[0] = id0_m[1] ^ id0_m[2] ^ id0_m[3] ^ id0_m[4] ^ id0_m[5] ^ id0_m[6] ^ id0_m[7] ^ id0_m[8] ^ id0_m[9];
assign 	   mask_id[1] = id1_m[1] ^ id1_m[2] ^ id1_m[3] ^ id1_m[4] ^ id1_m[5] ^ id1_m[6] ^ id1_m[7] ^ id1_m[8] ^ id1_m[9];
assign 	   mask_id[2] = id2_m[1] ^ id2_m[2] ^ id2_m[3] ^ id2_m[4] ^ id2_m[5] ^ id2_m[6] ^ id2_m[7] ^ id2_m[8] ^ id2_m[9];
assign 	   mask_id[3] = id3_m[1] ^ id3_m[2] ^ id3_m[3] ^ id3_m[4] ^ id3_m[5] ^ id3_m[6] ^ id3_m[7] ^ id3_m[8] ^ id3_m[9];

endmodule