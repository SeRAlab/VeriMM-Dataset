module top_module(
    input Clk,
    input  Reset,
    input Slt,
    input En,
    output reg [63:0] Output0 = 64'b0,
    output reg [63:0] Output1 = 64'b0
    );reg [3:0] cnt = 4'b0;
	
	always @(posedge Clk) begin
		if (Reset == 1) begin
			Output0 <= 64'b0;
			Output1 <= 64'b0;
			cnt <= 1'b0;
		end
		else begin
			if (En == 1) begin
				if (Slt == 0) begin
					Output0 <= Output0 + 64'b1;
				end
				else begin
					if (cnt == 3) begin
						cnt <= 4'b0;
						Output1 <= Output1 + 64'b1;
					end
					else begin
						cnt <= cnt + 4'b1;
					end
				end
			end
		end
	end

endmodule