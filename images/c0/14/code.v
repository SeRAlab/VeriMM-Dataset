module comp4 (
   q,
   a, b
   );
   input [3:0]   a, b;		
   output [2:0]  q;		
   assign q[0] = (a[3]&(|b[2:0])) | (a[2]&(|b[1:0])) | (a[1]&(|b[0:0]));
   assign q[1] = (a[2]&(|b[3:3])) | (a[1]&(|b[3:2])) | (a[0]&(|b[3:1]));
   assign q[2] = (a[3]&b[3]) | (a[2]&b[2]) | (a[1]&b[1]) | (a[0]&b[0]);
endmodule