module vending_machine (
        input clk,
        input areset,
        input coin_inserted,
        input item_taken,
        output reg dispense);parameter Idle=1'b0, Dispense=1'b1;
	reg state;
	always @(posedge clk, posedge areset) begin
		if (areset)
			state <= Idle;
		else begin
			case (state)
				Idle: state <= coin_inserted ? Dispense : Idle;
				Dispense: state <= item_taken ? Idle : Dispense;
			endcase
		end
	end
	
	assign dispense = (state == Dispense);
	
endmodule