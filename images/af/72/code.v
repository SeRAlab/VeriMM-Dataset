module shift_register_8bit(clk, reset, load, shift, D, Q);
     input clk;
     input reset;
     input load;
     input shift;
     input [7:0] D;
     output [7:0] Q;

     reg [7:0] Q;

     always @(posedge clk) begin
         if (reset)
             Q <= 8'b0;
         else if (load)
             Q <= D;
         else if (shift)
             Q <= {Q[6:0], 1'b0};
     end
endmodule