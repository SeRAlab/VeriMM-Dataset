module top_module(ip,clk,rst,q,qb);input ip, clk, rst;
    output reg q;
    output qb;

    assign qb = ~q;

    

    always @(posedge clk) begin
        if(rst) begin
            q<=0;
        end
        else begin
            q<=ip;
        end
    end

endmodule