module top_module(
	input wire clk, reset,
	input wire tick,
	input wire [7:0] data_in,
	output wire [7:0] data_out
    );reg [1:0] state_reg , state_next;
reg [22:0] n_reg , n_next;
reg [7:0] code, code_next;


localparam
wait_tick = 1'b0,
get_pulse = 1'b1;






always @(posedge clk, posedge reset)
if (reset)
begin
	state_reg <= wait_tick;
	code <= 0;
	n_reg <=0;	
end

else
begin
	state_reg <= state_next;
	n_reg <= n_next;
	code <= code_next;
end
	
always @*
begin
	state_next = state_reg;
	n_next = n_reg;
	code_next = code;


case (state_reg)
wait_tick:
			if (tick)
				begin
					n_next = 23'd5000000;
					state_next = get_pulse;
				end
get_pulse: 
				begin
					if (n_reg==0)
					begin
						code_next = 0;
						state_next = wait_tick;
					end
					else
					begin
						code_next = data_in;
						n_next = n_reg - 1'b1;
					end
				end
endcase

end

assign data_out = code;

endmodule