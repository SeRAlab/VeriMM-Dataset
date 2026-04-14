module top_module (
        input clk,
        input areset,
        input move_up,
        input move_down,
        output reg [1:0] at_floor);parameter GroundFloor = 3'b001, FirstFloor = 3'b010, SecondFloor = 3'b100;
	reg [2:0] state;
	always @(posedge clk, posedge areset) begin
		if (areset)
			state <= GroundFloor;
		else begin
			case (state)
				GroundFloor: state <= move_up ? FirstFloor : GroundFloor;
				FirstFloor: state <= move_up ? SecondFloor : (move_down ? GroundFloor : FirstFloor);
				SecondFloor: state <= move_down ? FirstFloor : SecondFloor;
			endcase
		end
	end
	
	assign at_floor = (state == GroundFloor) ? 2'b00 :
	                  (state == FirstFloor) ? 2'b01 :
	                  2'b10;
endmodule