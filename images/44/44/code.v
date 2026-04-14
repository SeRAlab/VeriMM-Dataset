module top_module(
    input wire wHClk_i,		
    input wire wLClk_i,		
    input wire wTrig_i,		
    output wire wTrig_o,		
    input wire wReset_i      
    );localparam S_IDLE = 2'h0;
localparam S_STRIG = 2'h1;
localparam S_LTRIG = 2'h2;


reg [1:0] rState;
reg [1:0] rLEdge;
wire      wLEdge;

assign wLEdge = ~rLEdge[1] && rLEdge[0];
assign wTrig_o = wTrig_i || (rState != S_IDLE) ; 

always @ (posedge wHClk_i)
begin
	rLEdge <= {rLEdge[0], wLClk_i};
	if (wReset_i)
		begin
			rState <= S_IDLE;
		end
	else
		begin
			case (rState)
				S_IDLE:
					rState <= wTrig_i ? S_STRIG : S_IDLE;
				S_STRIG:
						begin
							rState 		<= wLEdge ? S_LTRIG : S_STRIG;
						end
				S_LTRIG:
						begin
							rState 		<= wLEdge ? S_IDLE : S_LTRIG;
						end
				default:
					rState <= S_IDLE;
			endcase
		end
end
endmodule