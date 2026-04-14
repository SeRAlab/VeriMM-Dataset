module top_module(input clk,
                  input            rst,
                  
                  input            we,
                  input [7:0]      idata,

                  input            re,
                  output reg [7:0] wdata,

                  output           oready,
                  output           full);reg [8:0]                   q1,q2,q3,q4,q5,q6,q7,q8,q9,q10;
   wire [8:0]                  q1n,q2n,q3n,q4n,q5n,q6n,q7n,q8n,q9n,q10n;
   wire                        q1m,q2m,q3m,q4m,q5m,q6m,q7m,q8m,q9m;

   assign full = q10[8];
   assign oready = q1m;

   assign q1n = we ? {1'b0, idata} : q1;
   assign q2n = q1m ? {1'b0, q1[7:0]} : q2;
   assign q3n = q2m ? {1'b0, q2[7:0]} : q3;
   assign q4n = q3m ? {1'b0, q3[7:0]} : q4;
   assign q5n = q4m ? {1'b0, q4[7:0]} : q5;
   assign q6n = q5m ? {1'b0, q5[7:0]} : q6;
   assign q7n = q6m ? {1'b0, q6[7:0]} : q7;
   assign q8n = q7m ? {1'b0, q7[7:0]} : q8;
   assign q9n = q8m ? {1'b0, q8[7:0]} : q9;
   assign q10n = q9m ? {1'b0, q9[7:0]} : q10;

   assign q1m = q2m | !q2[8];
   assign q2m = q3m | !q3[8];
   assign q3m = q4m | !q4[8];
   assign q4m = q5m | !q5[8];
   assign q5m = q6m | !q6[8];
   assign q6m = q7m | !q7[8];
   assign q7m = q8m | !q8[8];
   assign q8m = q9m | !q9[8];
   assign q9m = re  | !q10[8];

   always @(posedge clk) begin
      if (rst) begin
         q1 <= 0; q2 <= 0; q3 <= 0; q4 <= 0;
         q5 <= 0; q6 <= 0; q7 <= 0; q8 <= 0;
         q9 <= 0; q10 <= 0;
      end
      else begin
         q1 <= q1n; q2 <= q2n; q3 <= q3n; q4 <= q4n;
         q5 <= q5n; q6 <= q6n; q7 <= q7n; q8 <= q8n;
         q9 <= q9n; q10 <= q10n;
         if (re && oready) begin
            wdata <= q1[7:0];
         end
      end
   end
endmodule