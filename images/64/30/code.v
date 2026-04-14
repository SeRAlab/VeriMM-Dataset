module top_module(input rst, clk,
		input [1:0] memRead, memWrite, 
		input [15:0] addr, 
		input [15:0] writeData, 
		output reg [15:0] readData);reg [15:0] mem [15:0];
	reg [15:0] temp1, temp2;
	always @ (posedge clk, negedge rst) begin
		if (!rst) begin
			readData = 0;
			mem[0] <= 16'h3142;
			mem[2] <= 16'h0000;
			mem[4] <= 16'h5678;
			mem[6] <= 16'hDEAD;
			mem[8] <= 16'hBEEF;
		end
		
	end
	always@(*) begin
			if (memRead == 2'b01) 
				readData <= mem[addr];
			else if(memRead == 2'b10) begin
				temp1 <= mem[addr];
				readData <= {8'b0, temp1[7:0]};
			end


			if (memWrite == 2'b01)
                                mem[addr] <= writeData;
                        else if (memWrite == 2'b10) begin
                                temp2 <= writeData;
                                mem[addr] <= temp2[7:0];
                        end
	end
endmodule