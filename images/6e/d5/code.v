module top_module(
	 output [15:0] yout,
	 input [15:0] ain,
	 input [4:0] bin,
	 input rotate,
	 input sra
    );wire [3:0] b;
	wire [15:0] a;
	wire [15:0] y;
	wire s;
	wire [7:0]rb3;
	wire [15:0]b3;
	wire [3:0]rb2;
	wire [15:0]b2;
	wire [1:0]rb1;
	wire [15:0]b1;
	wire rb0;
	
	wire left;
	
	
	
	assign left = (bin[4])?(1'b1):(1'b0);
	
	
	assign b = (left)?(~bin[3:0]):(bin[3:0]);
	
	
	genvar m;
	   generate
		for (m=0; m < 15; m=m+1) begin : REVERSE_INPUT
			assign a[m] = (left)?(ain[14-m]):(ain[m]);
		end
   endgenerate
	
	assign a[15] = (left)?((rotate)?(ain[15]):(1'b0)):(ain[15]);	
		
	
	
	assign s = (sra)?(a[15]):(1'b0);
	
	genvar c, d, e, f, g, h, i, j;
 
	
   generate
		for (d=0; d < 8; d=d+1) begin : ROTATE_B3
			assign rb3[d] = (rotate)?(a[d]):(s);
		end
   endgenerate

	
   generate
		for (c=0; c < 16; c=c+1) begin : B3
			if(c < 8)
				assign b3[c] = (b[3])?(a[c+8]):(a[c]);
			else
				assign b3[c] = (b[3])?(rb3[c-8]):(a[c]);
		end
   endgenerate
	
	
   generate
		for (e=0; e < 4; e=e+1) begin : ROTATE_B2
			assign rb2[e] = (rotate)?(b3[e]):(s);
		end
   endgenerate
	
	
   generate
		for (f=0; f < 16; f=f+1) begin : B2
			if(f < 12)
				assign b2[f] = (b[2])?(b3[f+4]):(b3[f]);
			else
				assign b2[f] = (b[2])?(rb2[f-12]):(b3[f]);
		end
   endgenerate
	
	
   generate
		for (g=0; g < 2; g=g+1) begin : ROTATE_B1
			assign rb1[g] = (rotate)?(b2[g]):(s);
		end
   endgenerate
	
	
   generate
		for (h=0; h < 16; h=h+1) begin : B1
			if(h < 14)
				assign b1[h] = (b[1])?(b2[h+2]):(b2[h]);
			else
				assign b1[h] = (b[1])?(rb1[h-14]):(b2[h]);
		end
   endgenerate
	
	
	assign rb0 = (rotate)?(b1[0]):(s);
	
	
   generate
		for (j=0; j < 16; j=j+1) begin : B0
			if(j < 15)
				assign y[j] = (b[0])?(b1[j+1]):(b1[j]);
			else
				assign y[j] = (b[0])?(rb0):(b1[j]);
		end
   endgenerate

	
	
	genvar n;
	generate
		for (n=0; n < 16; n=n+1) begin : REVERSE_OUTPUT
			assign yout[n] = (left)?(y[15-n]):(y[n]);
		end
   endgenerate

endmodule