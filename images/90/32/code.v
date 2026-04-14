module top_module(
    input clk,
    input reset,   
    input s,
    input w,
    output z
);reg[1:0] state, next_state;
	reg[1:0] cnt;

	parameter A = 0, S0 = 1, S1 = 2, S2 = 3;
	
	
	always@(posedge clk)begin
		if(reset)begin
			state <= A;
		end
		else begin
			state <= next_state;
		end
	end
	
	always@(*)begin
		case(state)
			A : begin next_state = s ? S0 : A; end
			S0 : begin next_state = S1; end
			S1 : begin next_state = S2; end
			S2 : begin next_state = S0; end
		endcase
	end
	
	always@(posedge clk)begin
		if(reset)
			cnt <= 0;
		else if(state == S0)
            cnt   <=  w;
        else if(state == S1 || state == S2)
            cnt   <=  cnt + w;			
	end
	
	assign z = (state == S0) && (cnt == 2);
	
endmodule