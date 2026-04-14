module top_module(in1, in2, cin, sum, cout);parameter N = 32;
input [N - 1:0] in1;
input [N - 1:0] in2;
input cin;
output [N - 1:0] sum;
output cout;



wire [N - 1:0] gen;
wire [N - 1:0] pro;
wire [N:0] c_temp;

genvar j, i;
generate

 assign c_temp[0] = cin;
 
 
 for(j = 0; j < N; j = j + 1) begin: carry_functions
 assign gen[j] = in1[j] & in2[j];
 assign pro[j] = in1[j] | in2[j];
 assign c_temp[j+1] = gen[j] | pro[j] & c_temp[j];
 end
 
 
 assign cout = c_temp[N];
 
 
 
 for(i = 0; i < N; i = i+1) begin: sum_without_carry
 assign sum[i] = in1[i] ^ in2[i] ^ c_temp[i];
 end 
endgenerate 
endmodule