module top_module(CLK, D, Q, CO, ENABLE, LOAD, UP, CLR);input CLK, ENABLE, LOAD, UP, CLR;
input [3:0] D;
output CO;
output [3:0] Q;

reg [3:0] Qin;
assign Q = Qin;
assign CO = ENABLE & ( (UP & Q[3] & !Q[2] & !Q[1] & Q[0]) || 
	(!UP & !Q[3] & !Q[2] & !Q[1] & !Q[0]) );

always @(posedge CLK, negedge CLR)
begin
if (!CLR)
  Qin <= 4'b0000;
else if (LOAD & ENABLE)
  Qin <= D;
else if (UP & ENABLE)
  begin
    if (Qin == 4'b1001)
      Qin <= 4'b0000;
    else
      Qin <= Qin + 1;
  end
else if (!UP & ENABLE)
  begin
    if (Qin == 4'b0000)
      Qin <= 4'b1001;
    else
      Qin <= Qin - 1;
  end
end
endmodule