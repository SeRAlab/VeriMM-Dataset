module security_gate_controller (
        input clk,
        input areset,
        input open_signal,
        input close_signal,
        output reg gate_open);parameter Gate_Closed=1'b0, Gate_Open=1'b1;
	reg state;
	always @(posedge clk, posedge areset) begin
		if (areset)
			state <= Gate_Closed;
		else begin
			case (state)
				Gate_Closed: state <= open_signal ? Gate_Open : Gate_Closed;
				Gate_Open: state <= close_signal ? Gate_Closed : Gate_Open;
			endcase
		end
	end
	
	assign gate_open = (state == Gate_Open);
	
endmodule