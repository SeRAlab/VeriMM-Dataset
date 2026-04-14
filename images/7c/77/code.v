module top_module(D,R,S,T,J,K,clk,DLatchOut,DFFOut,RSOUt,TOUt,JKOut);input D,R,S,T,J,K,clk;
reg QDLatch,QDFF,QRS,QT,QJK;
output DLatchOut,DFFOut,RSOUt,TOUt,JKOut;



always @ (clk)
begin
QDLatch= clk ? D : QDLatch;
end 

always @ (posedge clk)
begin
QDFF = D;
QT = T ^ QT;
QJK = (J & ~QJK) | (~K & QJK); 
QRS= ~R ? S : 0;

end

assign DLatchOut = QDLatch;
assign DFFOut = QDFF;
assign RSOUt = QRS;
assign TOUt = QT;
assign JKOut = QJK;

endmodule