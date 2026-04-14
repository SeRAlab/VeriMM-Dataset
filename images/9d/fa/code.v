module top_module(clk, rstn, set, ready);input clk, rstn;
input[1:0] set;
output reg ready;

reg state;
reg nxt_state;
reg [16:0] timer;

parameter inicio = 1'b0, contador = 1'b1;

always @(*) begin
	case(state)
		inicio:begin
			if(set == 2'b01)begin
				nxt_state = contador;
			end
			else if(set == 2'b10)begin
				nxt_state = contador;
			end
			else if(set == 2'b11)begin
				nxt_state = contador;
			end			
		end
		
		contador:begin
			if(set == 2'b00)
				nxt_state = inicio;
			else if(timer > 14'b0)begin 
				nxt_state = contador;
			end
			else begin
				nxt_state = inicio;
			end
		end

		default:
			nxt_state = inicio;
	endcase
end

always @(posedge clk) begin
   if(rstn) begin
		state <= inicio;
	end
	else begin
		state <= nxt_state;
		
		case(state)
			inicio:begin
				if(set == 2'b01)begin
					timer <= 10000;	
					ready <= 1'b0;
				end
				else if(set == 2'b10)begin
					timer <= 20000;
					ready <= 1'b0;
				end
				else if(set == 2'b11)begin
					timer <= 100000;
					ready <= 1'b0;
				end			
				else begin
					timer <= 0;
					ready <= 0;
				end
			end
		
			contador:begin
				if(timer > 14'b0)begin 
					timer <= timer - 1;
				end
				else begin
					ready <= 1'b1;
					timer <= 0;
				end
			end
		endcase
	end	
end
	
endmodule