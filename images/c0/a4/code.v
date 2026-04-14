module counter(
	 input CS,
    input WR,	
	 input clk,	
    input cmd,
	 input [7:0]din,
	 output [7:0]dout,
	 output reg [7:0]mode,	
	 input [1:0]CE	
    );
	 reg [15:0]count = 0;
	 reg [15:0]init = 0;
	 reg [1:0]state = 0; 
	 reg strobe = 0;
	 reg rd = 0;
	 reg latch = 0;
	 reg newcmd = 0;
	 wire c1 = count == 1;
	 wire c2 = count == 2;
	 reg CE1 = 0;
	 assign dout = mode[5] & (~mode[4] | rd) ? count[15:8] : count[7:0];
	always @(posedge clk) begin
		if(CE == 2'b10) CE1 <= 1;
		if(CS) begin
			if(WR) begin
				mode[6] <= 1;
				rd <= 0;
				latch <= 0;
				if(cmd) begin	
					if(|din[5:4]) begin
						mode[5:0] <= din[5:0];
						newcmd <= 1;
						state <= {1'b0, din[5] & ~din[4]};
					end else latch <= &mode[5:4];
				end else begin	
					state <= state[0] + ^mode[5:4] + 1;
					if(state[0]) init[15:8] <= din;
					else init[7:0] <= din;
				end
			end else begin
				rd <= ~rd;
				if(rd) latch <= 0;
			end
		end else if(state[1] && CE1 && !latch) begin
			newcmd <= 0;
			CE1 <= 0;
			case(mode[3:1])
				3'b000, 3'b001:
					if(mode[6]) begin
						mode[7:6] <= 2'b00;
						count <= init;
					end else begin
						count <= count - 1;
						if(c1) mode[7] <= 1;
					end
				3'b010, 3'b110: begin
					mode[7] <= ~c2;
					if(c1 | newcmd) begin
						mode[6] <= 1'b0;
						count <= init;
					end else count <= count - 1;
				end
				3'b011, 3'b111: begin
					if(c1 | c2 | newcmd) begin
						mode[7:6] <= {~mode[7] | newcmd, 1'b0};
						count <= {init[15:1], (~mode[7] | newcmd) & init[0]};
					end else count <= count - 2;
				end
				3'b100, 3'b101:
					if(mode[6]) begin
						mode[7:6] <= 2'b10;
						count <= init;
						strobe <= 1;
					end else begin
						count <= count - 1;
						if(c1) begin
							if(strobe) mode[7] <= 0;
							strobe <= 0;
						end else mode[7] <= 1;
					end
			endcase
		end
	end
endmodule