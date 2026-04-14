module top_module(i1,i2,i3,i4,i5,i6,i7,i8,s1,s2,s3,a1);input i1,i2,i3,i4,i5,i6,i7,i8,s1,s2,s3;
	output a1;
	
	
	assign a1=((i1&(!s1)&(!s2)&(!s3))|(i2&(!s1)&(!s2)&(s3))|(i3&(!s1)&(s2)&(!s3))|(i4&(!s1)&(s2)&(s3))|(i5&(s1)&(!s2)&(!s3))|(i6&(s1)&(!s2)&(s3))|(i7&(s1)&(s2)&(!s3))|(i8&(s1)&(s2)&(s3)));

endmodule