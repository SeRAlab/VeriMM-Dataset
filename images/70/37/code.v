module top_module(
    input CLK,
    output [7:0] DISP1,
    output [3:0] AN1
    );wire [31:0] N = 35000;
reg [31:0] cnt;
reg [1:0] count=0;
reg [7:0] DISP2;
reg [3:0] AN2;
always @ (posedge CLK) begin
	if(cnt==N-1) begin
		cnt <= 0;
		case (count%4)
			0: begin
					AN2 <= 4'b1110;
					DISP2 <= 8'b11111001;
				end
			1: begin
					AN2 <= 4'b1101;
					DISP2 <= 8'b10100100;
				end
			2: begin
					AN2 <= 4'b1011;
					DISP2 <= 8'b10110000;
				end
			3: begin
					AN2 <= 4'b0111;
					DISP2 <= 8'b10011001;
				end
		endcase
		if (count == 3)
			count <= 0;
		else
			count <= count + 1;
	end
	else
		cnt <= cnt+1;
end
assign AN1 = AN2;
assign DISP1 = DISP2;
endmodule