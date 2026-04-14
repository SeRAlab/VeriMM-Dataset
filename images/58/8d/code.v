module top_module(cnt,signalCapteur,memo);input signalCapteur;
input [15:0] cnt;
output reg[15:0] memo;

always@(negedge(signalCapteur))
begin
	memo <= cnt;
end
endmodule