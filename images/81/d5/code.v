module top_module(
  input                clk,
  input                rst_n,
  output reg  [31:0]   Q
);reg [31:0] Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12, Q13, Q14, Q15, Q16;
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      Q1 <= 1'b0;
      Q2 <= 1'b0;
      Q3 <= 1'b0;
      Q4 <= 1'b0;
      Q5 <= 1'b0;
      Q6 <= 1'b0;
      Q7 <= 1'b0;
      Q8 <= 1'b0;
      Q9 <= 1'b0;
      Q10 <= 1'b0;
      Q11 <= 1'b0;
      Q12 <= 1'b0;
      Q13 <= 1'b0;
      Q14 <= 1'b0;
      Q15 <= 1'b0;
      Q16 <= 1'b0;
      Q <= 32'h00000000;
    end else begin
      Q1 <= Q[0] ^ Q[1];
      Q2 <= Q1 ^ Q[2];
      Q3 <= Q2 ^ Q[3];
      Q4 <= Q3 ^ Q[4];
      Q5 <= Q4 ^ Q[5];
      Q6 <= Q5 ^ Q[6];
      Q7 <= Q6 ^ Q[7];
      Q8 <= Q7 ^ Q[8];
      Q9 <= Q8 ^ Q[9];
      Q10 <= Q9 ^ Q[10];
      Q11 <= Q10 ^ Q[11];
      Q12 <= Q11 ^ Q[12];
      Q13 <= Q12 ^ Q[13];
      Q14 <= Q13 ^ Q[14];
      Q15 <= Q14 ^ Q[15];
      Q16 <= Q15 ^ Q[16];
      Q <= {Q16, Q15, Q14, Q13, Q12, Q11, Q10, Q9, Q8, Q7, Q6, Q5, Q4, Q3, Q2, Q1};
    end
  end
  
endmodule