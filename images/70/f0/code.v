module top_module(A1, A0,
	       		B1, B0,
	       		C1, C0,
	       		D1, D0,
 	       		S1, S0,
	       		Out1, Out0);input A1, A0;
	input B1, B0;
	input C1, C0;
	input D1, D0;
	input S1, S0;
	output Out1, Out0;
	reg Out1, Out0;

	always @* 
	begin
       		if(S1==0 && S0==0)
		begin
         		Out1 <= A1; Out0 <= A0;
		end
      		else if (S1==0 && S0==1)
		begin
         		Out1 <= B1; Out0 <= B0;
		end
      		else if (S1==1 && S0==0)
		begin
         		Out1 <= C1; Out0 <= C0;
		end
      		else
		begin
         		Out1 <= D1; Out0 <= D0;
		end
   	end

endmodule