module top_module(
    input rst,
    input start,
    input [3:0] d,
    input [3:0] D,
    input clk,
    output [3:0] qout
);wire [3:0] D1;
reg [3:0] r, d1, q;
reg [7:0] RD;


always@(posedge clk)
    if(rst) begin
        d1<= 4'd0;
    end
    else if(start) begin
        d1<= d;
    end

always@*
    if(D1>=d1) begin
        r = D1-d1;
        q = 1;
    end
    else begin
        r = D1;
        q = 0;
    end

always@(posedge clk)
    if(rst)
        RD<= 8'd0;
    else if(start) begin
        RD<={4'd0,D};
    end
    else begin
        RD <= {r,RD[2:0],q};
    end

assign qout = RD[3:0];endmodule