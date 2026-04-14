module top_module( 
	data,
	distance,
	result) ;input   [54:0]  data;
	input   [5:0]  distance;
	output   [54:0]  result;

	wire  direction_w;
	wire  [31:0]  pad_w;
	wire  [384:0]  sbit_w;

	assign
		direction_w = 1'b1,
		pad_w = {32{1'b0}},
		result = sbit_w[384:330],
		sbit_w = {((({55{(distance[5] & (~ direction_w))}} & {sbit_w[297:275], pad_w[31:0]}) | ({55{(distance[5] & direction_w)}} & {pad_w[31:0], sbit_w[329:307]})) | ({55{(~ distance[5])}} & sbit_w[329:275])), ((({55{(distance[4] & (~ direction_w))}} & {sbit_w[258:220], pad_w[15:0]}) | ({55{(distance[4] & direction_w)}} & {pad_w[15:0], sbit_w[274:236]})) | ({55{(~ distance[4])}} & sbit_w[274:220])), ((({55{(distance[3] & (~ direction_w))}} & {sbit_w[211:165], pad_w[7:0]}) | ({55{(distance[3] & direction_w)}} & {pad_w[7:0], sbit_w[219:173]})) | ({55{(~ distance[3])}} & sbit_w[219:165])), ((({55{(distance[2] & (~ direction_w))}} & {sbit_w[160:110], pad_w[3:0]}) | ({55{(distance[2] & direction_w)}} & {pad_w[3:0], sbit_w[164:114]})) | ({55{(~ distance[2])}} & sbit_w[164:110])), ((({55{(distance[1] & (~ direction_w))}} & {sbit_w[107:55], pad_w[1:0]}) | ({55{(distance[1] & direction_w)}} & {pad_w[1:0], sbit_w[109:57]})) | ({55{(~ distance[1])}} & sbit_w[109:55])), ((({55{(distance[0] & (~ direction_w))}} & {sbit_w[53:0], pad_w[0]}) | ({55{(distance[0] & direction_w)}} & {pad_w[0], sbit_w[54:1]})) | ({55{(~ distance[0])}} & sbit_w[54:0])), data};
endmodule