module top_module(output [3:0] OUT,
            input  [3:0] A,B,
	         input  C0	);wire C1,C2,C3;
				
				assign C1     = ((A[0]^B[0])&C0) | (A[0]&B[0]);
			   assign C2     = ((A[1]^B[1])&C1) | (A[1]&B[1]);
				assign C3     = ((A[2]^B[2])&C2) | (A[2]&B[2]);
       		
				
				assign OUT[0] = A[0]^B[0]^C0;
				assign OUT[1] = A[1]^B[1]^C1;
				assign OUT[2] = A[2]^B[2]^C2;
				assign OUT[3] = A[3]^B[3]^C3;endmodule