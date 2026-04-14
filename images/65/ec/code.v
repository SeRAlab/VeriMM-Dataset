module top_module(
    input clk,
    input oflow_Clr,
	 input oflow_in,
	 input gate,
    output reg oflow_state = 1'b0
    );reg gate_a = 1'b0, gate_b = 1'b0;

always @(posedge clk) begin
	gate_a <= gate;
	gate_b <= gate_a;
	if (~oflow_state) oflow_state <= (gate_b) ? oflow_in : oflow_state;
	else oflow_state <= (oflow_Clr) ? 1'b0 : oflow_state;
	end
endmodule