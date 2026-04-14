module top_module(

      
      input              clk,
      input              reset_n,
      
      output reg         in_ready,
      input              in_valid,
      input      [7: 0]  in_data,

      
      input              out_ready,
      output reg         out_valid,
      output reg [7: 0]  out_data
);reg  received_esc;
   wire escape_char, idle_char;

   
   
   

   assign idle_char = (in_data == 8'h4a);
   assign escape_char = (in_data == 8'h4d);

   always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         received_esc <= 0; 
      end else begin
         if (in_valid & out_ready) begin
            if ((idle_char | escape_char) & ~received_esc & out_ready) begin
                 received_esc <= 1;
            end else begin
                 received_esc <= 0;
            end
         end
      end
   end

   always @* begin
      
      out_valid = 1'b1;
      in_ready = out_ready & (~in_valid | ((~idle_char & ~escape_char) | received_esc));
      out_data = (~in_valid) ? 8'h4a :    
                 (received_esc) ? in_data ^ 8'h20 : 
                 (idle_char | escape_char) ? 8'h4d : 
                 in_data; 
   end
endmodule