module top_module( 
	data,
	distance,
	result) ;input   [54:0]  data;
	input   [5:0]  distance;
	output   [54:0]  result;

	wire  [6:0]  dir_w;
	wire  direction_w;
	wire  [31:0]  pad_w;
	wire  [384:0]  sbit_w;
	wire  [5:0]  sel_w;
	wire  [329:0]  smux_w;

	assign
		dir_w = {dir_w[5:0], direction_w},
		direction_w = 1'b1,
		pad_w = {32{1'b0}},
		result = sbit_w[384:330],
		sbit_w = {smux_w[329:0], data},
		sel_w = {distance[5:0]},
		smux_w = {((({55{(sel_w[5] & (~ dir_w[5]))}} & {sbit_w[297:275], pad_w[31:0]}) | ({55{(sel_w[5] & dir_w[5])}} & {pad_w[31:0], sbit_w[329:307]})) | ({55{(~ sel_w[5])}} & sbit_w[329:275])), ((({55{(sel_w[4] & (~ dir_w[4]))}} & {sbit_w[258:220], pad_w[15:0]}) | ({55{(sel_w[4] & dir_w[4])}} & {pad_w[15:0], sbit_w[274:236]})) | ({55{(~ sel_w[4])}} & sbit_w[274:220])), ((({55{(sel_w[3] & (~ dir_w[3]))}} & {sbit_w[211:165], pad_w[7:0]}) | ({55{(sel_w[3] & dir_w[3])}} & {pad_w[7:0], sbit_w[219:173]})) | ({55{(~ sel_w[3])}} & sbit_w[219:165])), ((({55{(sel_w[2] & (~ dir_w[2]))}} & {sbit_w[160:110], pad_w[3:0]}) | ({55{(sel_w[2] & dir_w[2])}} & {pad_w[3:0], sbit_w[164:114]})) | ({55{(~ sel_w[2])}} & sbit_w[164:110])), ((({55{(sel_w[1] & (~ dir_w[1]))}} & {sbit_w[107:55], pad_w[1:0]}) | ({55{(sel_w[1] & dir_w[1])}} & {pad_w[1:0], sbit_w[109:57]})) | ({55{(~ sel_w[1])}} & sbit_w[109:55])), ((({55{(sel_w[0] & (~ dir_w[0]))}} & {sbit_w[53:0], pad_w[0]}) | ({55{(sel_w[0] & dir_w[0])}} & {pad_w[0], sbit_w[54:1]})) | ({55{(~ sel_w[0])}} & sbit_w[54:0]))};
endmodule