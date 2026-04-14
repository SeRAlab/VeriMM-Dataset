module top_module(CE , CLK , CLR, Semnal);input CE,CLK,CLR;
reg [3:0]Count = 4'b0001;
output reg Semnal;



always @(posedge CLK)
	begin
		Semnal = 1'b0;															
		if(CLR == 1'b1)														
			begin
				Count = 4'b0001;
				Semnal = 1'b0;
			end
		else
				if(CE == 1'b1)														
					begin
						Count = Count + 1'b1;
						if(Count == 4'b1011)											
							Semnal = 1'b1;	
					end
	end
endmodule