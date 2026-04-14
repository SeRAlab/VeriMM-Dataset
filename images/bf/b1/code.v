module re1ce(den, din, clk, rst, trg, pls);
input   den;
input   din;
input   clk;
input   rst;
output  trg;
output  pls;
reg     QIn;
reg     [2:0] QSync;
wire    Rst_QIn;
assign Rst_QIn = (rst | pls);
always @(posedge din or posedge Rst_QIn) begin
    if(Rst_QIn)
        #1 QIn <= 1'b0;
    else if(den)
        #1 QIn <= den;
end
assign trg = QIn;
always @(posedge clk or posedge rst) begin
    if(rst)
        #1 QSync <= 3'b0;
    else 
        #1 QSync <= {QSync[0] & ~QSync[1], QSync[0], QIn};
end
assign pls = QSync[2];
endmodule