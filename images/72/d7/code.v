module top_module(
   output Q1, Q2,
   input  C,CE,D,R,S
);reg [1:0] Qi;

   always@(posedge C or posedge R) begin
      if (R) begin
         Qi[0] <= 1'b0;
      end
      else begin
         Qi[0] <= D;
      end
   end

   always@(negedge C or posedge R) begin
      if (R) begin
         Qi[1] <= 1'b0;
      end
      else begin
         Qi[1] <= D;
      end
   end

   assign Q1 = Qi[0];
   assign Q2 = Qi[1];

endmodule