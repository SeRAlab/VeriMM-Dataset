module top_module(
	input clk,
	input rst,
	input valid,
	input [1:0] hdb3_in,
	output checkv_out
    );reg [1:0] buffer0;
	reg [1:0] buffer1;
	reg [1:0] buffer2;
	reg [1:0] buffer3;
	reg [1:0] buffer4;
	
	always @(posedge clk) begin
		if (valid) begin
			buffer4 <= buffer3;
			buffer3 <= buffer2;
			buffer2 <= buffer1;
			buffer1 <= buffer0;
			buffer0 <= hdb3_in;
		end	
	end
	reg [4:0]flag;
	wire broken = (((buffer3 == hdb3_in)&&(buffer2 == 2'b00)&&(buffer1 == 2'b00)&&(buffer0 == 2'b00)) || ((buffer2 == hdb3_in)&&(buffer1 == 2'b00)&&(buffer0 == 2'b00))) &&( hdb3_in != 2'b00);

	always @(posedge clk) begin
		if(valid)begin
			if(broken)begin
				flag <= {flag[3],4'b0000};
			end
			else begin
				flag <= {flag[3:0],hdb3_in != 2'b00};
			end
		end
	end
	assign checkv_out = flag[4];
endmodule