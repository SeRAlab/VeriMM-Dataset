module top_module(input wire[3:0] bin,output reg[4:0] BCD
    );always @(*)
		begin
			if(bin<4'b1010)
				begin
					BCD[4]<=0;
					BCD[3:0]<=bin[3:0];
				end
			else
				begin
					BCD[4]<=1;
					BCD[3:0]<=bin-4'b1010;
				end
		end

endmodule