module top_module(input wire [5:0] i_a,input wire [5:0] i_b,output wire [10:0] o_r);assign o_r[10] = (i_a[5]&i_b[5]); 
  assign o_r[ 9] = (i_a[4]&i_b[5]) ^ (i_a[5]&i_b[4]); 
  assign o_r[ 8] = (i_a[3]&i_b[5]) ^ (i_a[4]&i_b[4]) ^ (i_a[5]&i_b[3]); 
  assign o_r[ 7] = (i_a[2]&i_b[5]) ^ (i_a[3]&i_b[4]) ^ (i_a[4]&i_b[3]) ^ (i_a[5]&i_b[2]); 
  assign o_r[ 6] = (i_a[1]&i_b[5]) ^ (i_a[2]&i_b[4]) ^ (i_a[3]&i_b[3]) ^ (i_a[4]&i_b[2]) ^ (i_a[5]&i_b[1]); 
  assign o_r[ 5] = (i_a[0]&i_b[5]) ^ (i_a[1]&i_b[4]) ^ (i_a[2]&i_b[3]) ^ (i_a[3]&i_b[2]) ^ (i_a[4]&i_b[1]) ^ (i_a[5]&i_b[0]); 
  assign o_r[ 4] = (i_a[0]&i_b[4]) ^ (i_a[1]&i_b[3]) ^ (i_a[2]&i_b[2]) ^ (i_a[3]&i_b[1]) ^ (i_a[4]&i_b[0]); 
  assign o_r[ 3] = (i_a[0]&i_b[3]) ^ (i_a[1]&i_b[2]) ^ (i_a[2]&i_b[1]) ^ (i_a[3]&i_b[0]); 
  assign o_r[ 2] = (i_a[0]&i_b[2]) ^ (i_a[1]&i_b[1]) ^ (i_a[2]&i_b[0]); 
  assign o_r[ 1] = (i_a[0]&i_b[1]) ^ (i_a[1]&i_b[0]); 
  assign o_r[ 0] = (i_a[0]&i_b[0]); 
 endmodule