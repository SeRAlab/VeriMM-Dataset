module top_module(
   
   ack_clk1, ack_clk2, clkout,
   
   clk1, clk2, req_clk1, req_clk2, select, rst_n
   );input clk1;
   input clk2;

   input req_clk1;
   output ack_clk1;

   input req_clk2;
   output ack_clk2;

   output clkout;
   input  select; 

   input  rst_n; 



   
   

   
   
   reg                  ack_clk1;
   reg                  ack_clk2;
   
   

   


   wire   select; 
   wire    select1_a;
   reg    select1_m;
   reg    select1_r;
   wire   select2_a;
   reg    select2_m;
   reg    select2_r;
   wire   clkout;

   assign select1_a = !select &!select2_r;
   assign select2_a = select &!select1_r;


   
   always @(posedge clk1 or negedge rst_n) begin
      if(rst_n == 1'b0) begin
         
         
         select1_m <= 1'h0;
         select1_r <= 1'h0;
         
      end
      else begin
         select1_m <= select1_a;
         select1_r <= select1_m;

      end
   end


   always @(posedge clk2 or negedge rst_n) begin
      if(rst_n == 1'b0) begin
         
         
         select2_m <= 1'h0;
         select2_r <= 1'h0;
         
      end
      else begin
         select2_m <= select2_a;
         select2_r <= select2_m;
      end
   end

   
   assign clkout = ((!clk1 & select1_r) |  (!clk2 & select2_r));



endmodule