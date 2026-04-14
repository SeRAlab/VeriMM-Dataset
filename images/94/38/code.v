module top_module(input clk, input rst,input baud_t_enable, input data_t_enable, input [7:0]data, output txd, output tbr);reg t_busy; 
reg [3:0]i;						
reg [9:0]t_shift_reg; 
reg [3:0]t_count; 		

assign txd = t_shift_reg[0];
assign tbr = ~t_busy;
always@(posedge clk) begin
	if(rst)begin
		t_shift_reg <= 10'h3ff;
		t_count <= 0;
		t_busy <= 0;
	end

	else if(baud_t_enable && t_busy) begin
		for(i=0 ; i < 4'b1001; i=i+1)
			t_shift_reg[i] <= t_shift_reg[i+1];
		t_shift_reg[9] <= 1'b1;
		t_count <= t_count - 1'b1;
		if(t_count == 0)
			t_busy <= 1'b0;
	end

	else if(data_t_enable)begin
		t_shift_reg[9:2] <= data[7:0];
		t_shift_reg[1] <= 1'b0;
		t_busy <=1'b1;		
		t_count <= 4'b1001;
	end
end
endmodule