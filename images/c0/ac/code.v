module redet(rst, clk, din, pls);
    input   rst;
    input   clk;
    input   din;
    output  pls;
    reg [2:0] QSync;
always @(posedge clk or posedge rst) begin
    if(rst)
        #1 QSync <= 3'b0;
    else 
        #1 QSync <= {QSync[0] & ~QSync[1], QSync[0], din};
end
assign pls = QSync[2];
endmodule