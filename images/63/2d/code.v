module top_module(input clk, input rst,
   input xon_rcvd, input xoff_rcvd, output reg inhibit_tx);reg [15:0] state;
   always @(posedge clk) begin
     if(rst) begin
       state <= 0;
     end else if(xoff_rcvd) begin
       state <= 255;
     end else if(xon_rcvd) begin
       state <= 0;
     end else if(state !=0) begin
       state <= state - 1;
     end
   end

   always @(posedge clk) begin
     inhibit_tx <= (state != 0);
   end
   
endmodule