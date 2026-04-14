module top_module(rst_n, cs, sck, mosi, miso, ctl, data, ret_data);input rst_n, cs, sck, mosi;
input [7:0] ret_data;
output reg [7:0] ctl, data;
output reg miso;

reg [3:0] i;
reg [2:0] j;

always @(negedge rst_n or posedge cs or negedge sck)
begin
	if (~rst_n)
	begin
		miso <= 1'b0;
		i <= 4'b1111;
		j <= 3'b111;
	end
	else if (cs)
	begin
		miso <= 1'b0;
		i <= 4'b1111;
		j <= 3'b111;
	end
	else if (i > 4'b0111)
	begin	
		miso <= 1'b0;
		ctl[j] <= mosi;
		j <= j - 3'b1;
		i <= i - 4'b1;
	end
	else
	begin
		miso <= ret_data[i];
		data[i] <= mosi;
		i <= i - 4'b1;
	end
end

endmodule