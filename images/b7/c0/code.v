module top_module(
    input clk, 
    input sw,  
    output reg sw_state  
    );reg sw_sync_0;
always @(posedge clk) sw_sync_0 <= sw; 
reg sw_sync_1;
always @(posedge clk) sw_sync_1 <= sw_sync_0;


reg [15:0] sw_cnt;
always @(posedge clk)
if(sw_state==sw_sync_1)
    sw_cnt <= 0;
else
begin
    sw_cnt <= sw_cnt + 1'b1;  
    if(sw_cnt == 16'hffff) sw_state <= ~sw_state;  
end
endmodule