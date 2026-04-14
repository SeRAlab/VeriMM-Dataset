module top_module(NewDataKB,Load, New , Borrar, EndTras, ParityCoherente, Clk , Reset);input NewDataKB, EndTras, ParityCoherente, Clk, Reset;
output reg Load, New , Borrar;

 reg [1:0]state;
 parameter Sleep  = 3'h0;
 parameter Trasmitir  = 3'h1;
 parameter Wait  = 3'h3;
 parameter NewS  = 3'h2;


always @(negedge Clk) begin
	if (Reset)
		state = Sleep;
	else begin
		case(state)
		Sleep:begin
			if(NewDataKB) state=Trasmitir;
			else state=Sleep;
		end
		Trasmitir:begin
			if(EndTras) begin
				if(ParityCoherente)state=NewS;
				else state=Sleep;
			end
			else state=Wait ;
		end
		Wait:begin
			if(NewDataKB) state=Trasmitir;
			else state=Wait;
		end
		NewS: state=Sleep;
		default: state = Sleep ;
		endcase
	end
end
always @(state) begin
  case(state)
    Sleep :begin
		Load=0;
		Borrar=1;
		New=0;
		end
    Wait :begin
		Load=0;
		Borrar=0;
		New=0;
		end
    Trasmitir:begin
		Load=1;
		Borrar=0;
		New=0;
		end
    NewS:begin
		Load=0;
		Borrar=0;
		New=1;
		end
    default:
      begin
		Load=0;
		Borrar=1;
		New=0;
       end
  endcase
end

endmodule