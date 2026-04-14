module shift_reg_4bit(D, clk, rst, Q);
     input D, clk, rst;
     output reg [3:0] Q;

     always @(posedge clk or posedge rst) begin
          if (rst)
               Q <= 4'b0000;
          else
               Q <= {Q[2:0], D};
     end
endmodule