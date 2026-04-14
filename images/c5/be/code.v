module adder (
   input [2:0] A,
   input [2:0] B,
   output [2:0] S,
   output Cout
);

   reg [3:0] temp_sum;
   assign S = temp_sum[2:0];
   assign Cout = temp_sum[3];

   always @* begin
      temp_sum = A + B;
   end

endmodule