module top_module(
 input clk,rst_n,
 input [7:0] data_Byte,
 input Rx_done,
 output reg [15:0]tiwen
 
    );reg [71:0]rx_data;
   reg[6:0]bt;
  always@(posedge clk or negedge rst_n)
begin
      if(!rst_n)
        begin
          rx_data<='d0;
          bt<='d0;
          tiwen<=16'd0;
         

        end
      else if(bt=='d9)
        begin
          bt<='d0; 
          tiwen<=rx_data[39:24];
          
    
        end          
      else if(Rx_done)
        begin
          bt<=bt+'d1;
          rx_data<={rx_data[63:0],data_Byte};
        end
      
end
      
endmodule