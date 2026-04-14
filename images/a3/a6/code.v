module top_module(clk,reset,trigger,counter,simu_ram_wr_req,simu_ram_wr_addr);input wire clk;
input wire reset;
input wire trigger;
output reg[15:0] counter;
output reg simu_ram_wr_req;
output reg[14:0] simu_ram_wr_addr;

reg[15:0] count;
always @(posedge clk)
begin

  if(reset)
  begin
    counter          = 16'b0;
    count            = 16'b0;
    simu_ram_wr_addr = 15'b0;
    simu_ram_wr_req  = 1'b0;
  end

  count = trigger ? count + 1'b1 : count;
  counter = count;

  if(trigger)
  begin
    simu_ram_wr_req = 1'b1;
    simu_ram_wr_addr = simu_ram_wr_addr + 1'b1;
  end
  else
  begin
    simu_ram_wr_req = 1'b0;
    simu_ram_wr_addr = simu_ram_wr_addr;   
  end
  
end
endmodule