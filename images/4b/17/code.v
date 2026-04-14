module top_module(
    input clk,
    input PB,  

    
    output reg PB_state,  
    output PB_down,  
    output PB_up   
);reg PB_sync_0;  always @(posedge clk) PB_sync_0 <= ~PB;  
reg PB_sync_1;  always @(posedge clk) PB_sync_1 <= PB_sync_0;


reg [15:0] PB_cnt;




wire PB_idle = (PB_state==PB_sync_1);
wire PB_cnt_max = &PB_cnt;	

always @(posedge clk)
if(PB_idle)
    PB_cnt <= 0;  
else
begin
    PB_cnt <= PB_cnt + 16'd1;  
    if(PB_cnt_max) PB_state <= ~PB_state;  
end

assign PB_down = ~PB_idle & PB_cnt_max & ~PB_state;
assign PB_up   = ~PB_idle & PB_cnt_max &  PB_state;
endmodule