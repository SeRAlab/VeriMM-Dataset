module counter_8bit(clk, reset, enable, Q);
     input clk;
     input reset;
     input enable;
     output [7:0] Q;

     reg [7:0] Q;

     always @(posedge clk or posedge reset) begin
         if (reset)
             Q <= 8'b0;
         else if (enable)
             Q <= Q + 1;
     end
endmodule