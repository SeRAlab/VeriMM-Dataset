module top_module(
    output [7 : 0] LED_out_rev,
    output [5 : 0] LED_ctrl_rev,
    input clk,
    input rst,
    input [23 : 0] data_in
    );reg [7 : 0] LED_out;
	reg [5 : 0] LED_ctrl;
	reg [3 : 0] LED_content;
	reg [19 : 0] timer;
	
	assign LED_out_rev = ~LED_out;
	assign LED_ctrl_rev = ~LED_ctrl;

	
	always @(posedge clk or negedge rst)
	begin
		if (rst == 0)
		begin
			timer = 0;
		end
		else
		begin
			timer = timer+1;
			if (timer >= 75000)
			begin
				timer = 0;
			end
			if (timer < 12500)
			begin
				LED_ctrl = 6'b011111;
				LED_content = data_in[23 : 20];
			end
			else if (timer < 25000)
			begin
				LED_ctrl = 6'b101111;
				LED_content = data_in[19 : 16];
			end
			else if (timer < 37500)
			begin
				LED_ctrl = 6'b110111;
				LED_content = data_in[15 : 12];
			end
			else if (timer < 50000)
			begin
				LED_ctrl = 6'b111011;
				LED_content = data_in[11 : 8];
			end
			else if (timer < 62500)
			begin
				LED_ctrl = 6'b111101;
				LED_content = data_in[7 : 4];
			end
			else
			begin
				LED_ctrl = 6'b111110;
				LED_content = data_in[3 : 0];
			end
			
			case (LED_content)
				4'b0000:	LED_out = 8'b00000011;
				4'b0001:	LED_out = 8'b10011111;
				4'b0010:	LED_out = 8'b00100101;
				4'b0011:	LED_out = 8'b00001101;
				4'b0100:	LED_out = 8'b10011001;
				4'b0101:	LED_out = 8'b01001001;
				4'b0110:	LED_out = 8'b01000001;
				4'b0111:	LED_out = 8'b00011111;
				4'b1000:	LED_out = 8'b00000001;
				4'b1001:	LED_out = 8'b00001001;
				4'b1010:	LED_out = 8'b00010001;
				4'b1011:	LED_out = 8'b11000001;
				4'b1100:	LED_out = 8'b01100011;
				4'b1101:	LED_out = 8'b10000101;
				4'b1110:	LED_out = 8'b01100001;
				4'b1111:	LED_out = 8'b01110001;
			endcase
		end
	end

endmodule