module loadable_counter_32bit (count, clk, reset, en, load, load_val);
   input clk, reset, en, load;
   input [31:0] load_val;
   output [31:0] count;
   
   reg [31:0] count;
   
   always @(posedge clk or posedge reset) begin
      if (reset)
         count <= 32'b0;
      else if (en) begin
         if (load)
            count <= load_val;
         else
            count <= count + 1;
      end
   end
   
endmodule