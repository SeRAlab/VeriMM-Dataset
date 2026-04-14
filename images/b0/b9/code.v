module top_module(
input clk,
input rst,
input [15:0] CLP_work_time,
input enable,
output reg [11:0] CLP_ctr_cnt,
output reg state
);always@(posedge clk) begin
    if(rst) begin
        CLP_ctr_cnt <= 0;
    end 
    else begin
        if(state == 0)
            CLP_ctr_cnt <= 0;
        else
            CLP_ctr_cnt <= CLP_ctr_cnt + 1;  
     end 
end 
  
always@(posedge clk)
    if(rst)
        state <= 0;
    else
        if(enable == 1)
            state <= 1;
        else
            if(CLP_ctr_cnt == CLP_work_time)
                state <= 0;
            else
                state <= state;
                
endmodule