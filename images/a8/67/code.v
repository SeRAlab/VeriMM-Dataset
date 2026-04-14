module top_module(nrst, clk, wr_req, rd_req, wr_sta, rd_sta);input nrst;
    input clk;
    input wr_req;
    input rd_req;
    output wr_sta;    // 处于写状态
    output rd_sta;    // 处于读状态
    
    reg wr_sta; 
    reg rd_pend;    // 读请求pending信号
    
    // 写状态转换
    always @(posedge clk or negedge nrst) begin
        if (~nrst) begin
            wr_sta <= 1'b0;
        end else begin
            wr_sta <= wr_req;
        end
    end
    
    // 读pending状态转换
    always @(posedge clk or negedge nrst) begin
        if (~nrst) begin
            rd_pend <= 1'b0;
        end else if (rd_req) begin
            rd_pend <= 1'b1;
        end else if (rd_sta) begin
            rd_pend <= 1'b0;
        end
    end
    
    // 当写状态无效且读pending时才可读
    assign rd_sta = rd_pend & ~wr_sta;
endmodule