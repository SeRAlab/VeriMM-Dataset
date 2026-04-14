module top_module(r,a,mode);input [3:0]a;
	input [2:0]mode;
	output reg [3:0]r;
	reg w1;
	

	always @(*)
		case (mode)
			3'b000:
				begin 
					r[3]=a[2];
					r[2]=a[1];
					r[1]=a[0];
					r[0]=0; 
				end
			3'b001:
				begin 
					r[3]=a[2];
					r[2]=a[1];
					r[1]=a[0];
					r[0]=1; 
				end
			3'b010:
				begin
					r[3]=0;
					r[2]=a[3];
					r[1]=a[2];
					r[0]=a[1];
				end
			3'b011:
				begin
					r[3]=1;
					r[2]=a[3];
					r[1]=a[2];
					r[0]=a[1];
				end
			3'b100:
				begin
					r[3]=a[2];
					r[2]=a[1];
					r[1]=a[0];
					r[0]=0;
				end
			3'b101:
				begin
					w1 = a[0];
					r[0]=a[1];
					r[1]=a[2];
					r[2]=a[3];
					r[3] = w1;
				end
			3'b110:
				begin
					w1 = a[3];
					r[3]=a[0];
					r[2]=a[1];
					r[1]=a[2];
					r[0] = w1;
				end
			3'b111:
				begin
					w1 = a[0];
					r[0]=a[1];
					r[1]=a[2];
					r[2]=a[3];
					r[3] = w1;
				end
		endcase
	
endmodule