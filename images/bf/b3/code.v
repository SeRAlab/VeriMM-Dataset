module vga_controller ( reset_n, clk_50, pixel, read_data, SW, VGA_R, VGA_G, VGA_B, LEDR, VGA_VS, VGA_HS, read_addr);
input reset_n;
input clk_50;
input [8:0] SW;
input [2:0] pixel;
input [2:0] read_data;
output reg [3:0] VGA_R;
output reg [3:0] VGA_G;
output reg [3:0] VGA_B;
output [9:0] LEDR;
output reg VGA_VS;
output reg VGA_HS;
output reg [10:0] read_addr;
reg clk_25;
reg [9:0] hc;
reg [9:0] vc;
reg vsenable;
wire vidon;
reg [11:0] vid_data;
assign LEDR[8:0] = SW;
assign LEDR[9] = reset_n;
always @ (posedge clk_50 or negedge reset_n)
begin
	if (!reset_n) begin
		clk_25 <= 0;
	end
	else begin
		clk_25 <= !clk_25;
	end
end
always @ (posedge clk_25 or negedge reset_n)
begin
	if (!reset_n) begin
		hc <= 0;
		VGA_HS <= 1;
		vsenable <= 0;
	end
	else if (hc < 640) begin
		hc <= hc + 1;
		vsenable <= 0;
		VGA_HS <= 1;
	end
	else if (hc < 640 + 16) begin
		VGA_HS <= 1;
		hc <= hc + 1;
		vsenable <= 0;
	end
	else if (hc < 640 + 16 + 96) begin
		VGA_HS <= 0;
		hc <= hc + 1;
		vsenable <= 0;
	end
	else if (hc < 640 + 16 + 96 + 48) begin
		VGA_HS <= 1;
		hc <= hc + 1;
		vsenable <= 0;
	end
	else begin
		VGA_HS <= 1;
		hc <= 0;
		vsenable <= 1;
	end
end
always @ (posedge clk_25 or negedge reset_n)
begin
	if (!reset_n) begin
		vc <= 0;
		VGA_VS <= 1;
	end
	else begin
		if (vsenable == 1) begin
			vc <= vc + 1;
		end
		if (vc < 480) begin
			VGA_VS <= 1;
		end
		else if (vc < 480 + 11) begin
			VGA_VS <= 1;
		end
		else if (vc < 480 + 11 + 2) begin
			VGA_VS <= 0;
		end
		else if (vc < 480 + 11 + 2 + 31) begin
			VGA_VS <= 1;
		end
		else begin
			vc <= 0;
			VGA_VS <= 1;
		end
	end
end
always @ (posedge clk_25) begin
		VGA_R[0] <= 0;
		VGA_G[0] <= 0;
		VGA_B[0] <= 0;
		VGA_R[1] <= 0;
		VGA_G[1] <= 0;
		VGA_B[1] <= 0;
		VGA_R[2] <= 0;
		VGA_G[2] <= 0;
		VGA_B[2] <= 0;
		VGA_R[3] <= 0;
		VGA_G[3] <= 0;
		VGA_B[3] <= 0;
	if (vidon == 1) begin
		if (hc < 480 && vc < 400) begin
			VGA_R[0] <= vid_data[0];
			VGA_R[1] <= vid_data[1];
			VGA_R[2] <= vid_data[2];
			VGA_R[3] <= vid_data[3];
			VGA_G[0] <= vid_data[4];
			VGA_G[1] <= vid_data[5];
			VGA_G[2] <= vid_data[6];
			VGA_G[3] <= vid_data[7];
			VGA_B[0] <= vid_data[8];
			VGA_B[1] <= vid_data[9];
			VGA_B[2] <= vid_data[10];
			VGA_B[3] <= vid_data[11];
		end
	end
end
always @ (*) begin
	if (hc < 400 && vc < 480) begin
		read_addr = hc/10 + (vc/10)*48;
				vid_data = 12'd10;
	end
	else begin
		read_addr = 10'd0;
		vid_data = 12'b101010101010;
	end 
end
assign vidon = (hc < 640 && vc < 480) ? 1 : 0;
endmodule