module top_module(clk, rst, op, a, b, result);input clk, rst, op;
   input [3:0] a, b;
   output [3:0] result;

   reg [3:0] reg_a;
   reg [3:0] reg_b;
   reg [3:0] reg_result;

   always @(posedge clk) begin
      if (rst) begin
         reg_a <= 4'b0;
         reg_b <= 4'b0;
         reg_result <= 4'b0;
      end else begin
         reg_a <= a;
         reg_b <= b;
         case(op)
            2'b00: reg_result <= reg_a + reg_b;
            2'b01: reg_result <= reg_a - reg_b;
            2'b10: reg_result <= reg_a * reg_b;
            2'b11: reg_result <= reg_a / reg_b;
         endcase
      end
   end

   assign result = reg_result;

endmodule