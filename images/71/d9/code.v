module top_module(  clk , data_in , pcout , reset ,write);input clk , reset,write;
 
input [63:0] data_in ;
output  reg [63:0]  pcout;
always @(posedge clk)
begin
    if(reset)
        pcout = 0 ;
    else
       if (write)
          pcout = data_in ;
end
endmodule