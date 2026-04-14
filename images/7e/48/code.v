module top_module(input[30:0] A,input[31:0]B,input[4:0]Ctr,output[31:0] R);wire[62:0] L0;
wire[46:0] L1;
wire[38:0] L2;
wire[34:0] L3;
wire[32:0] L4;

assign L0[62:0] = {A[30:0],B[31:0]};
generate
		genvar i; 
		
		for(i=0;i<=46;i=i+1)begin :for1
		assign L1[i] = (Ctr[4]&L0[i+16])|((~Ctr[4])&L0[i]);
		end
		
		for(i=0;i<=38;i=i+1)begin :for2
		assign L2[i] = (Ctr[3]&L1[i+8])|((~Ctr[3])&L1[i]);
		end
		
		for(i=0;i<=34;i=i+1)begin :for3
		assign L3[i] = (Ctr[2]&L2[i+4])|((~Ctr[2])&L2[i]);
		end
		
		for(i=0;i<=32;i=i+1)begin :for4
		assign L4[i] = (Ctr[1]&L3[i+2])|((~Ctr[1])&L3[i]);
		end
		
		for(i=0;i<=31;i=i+1)begin :for5
		assign R[i] = (Ctr[0]&L4[i+1])|((~Ctr[0])&L4[i]);
		end
		
endgenerate
endmodule