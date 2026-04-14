module register_16bit(clk, clear, load, D, Q);
     input clk;
     input clear;
     input load;
     input [15:0] D;
     output [15:0] Q;

     reg [15:0] Q;

     always @(posedge clk or posedge clear) begin
         if (clear)
             Q <= 16'b0;
         else if (load)
             Q <= D;
     end
endmodule