module top_module(
   input  rst_n,
   input  clk,

   output reg out_clk
   );reg [7:0] count;

   
   
   parameter RESET_COUNT = 8'd107;

   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         count[7:0]  <= 8'd0;
         out_clk     <= 1'b0;
      end else begin
         if(count[7:0] == RESET_COUNT) begin
            count[7:0]  <= 8'd0;
            out_clk     <= ~out_clk;
         end else begin
            count[7:0]  <= count[7:0] + 8'd1;
         end
      end
   end

endmodule