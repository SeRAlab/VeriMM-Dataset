module top_module(
    
      
      input              clk,
      
      input              reset_n,
      
      output reg         in_ready,
      input              in_valid,
      input      [31: 0] in_data,
      input      [ 5: 0] in_error,
      input              in_startofpacket,
      input              in_endofpacket,
      input      [ 1: 0] in_empty,
      
      input              out_ready,
      output reg         out_valid,
      output reg [31: 0] out_data,
      output reg [ 5: 0] out_error,
      output reg         out_startofpacket,
      output reg         out_endofpacket,
      output reg [ 1: 0] out_empty
);reg  [41: 0] in_payload;
   reg  [41: 0] out_payload;
   reg  [ 1: 0] ready;


   
   
   
   always @* begin
     in_payload = {in_data,in_error,in_startofpacket,in_endofpacket,in_empty};
     {out_data,out_error,out_startofpacket,out_endofpacket,out_empty} = out_payload;
   end

   
   
   
   always @* begin
     ready[1] = out_ready;
     out_valid = in_valid && ready[0];
     out_payload = in_payload;
     in_ready = ready[0];
   end


   always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
        ready[1-1:0] <= 0;
      end else begin
        ready[1-1:0] <= ready[1:1];
      end 
   end


endmodule