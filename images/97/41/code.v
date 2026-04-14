module top_module(
   input	 clk,
   input [7:0]	 X0,
   input [31:0]	 denom,
   output reg [31:0] recip
   );reg		 sign;
   reg [30:23]	 exp;
   reg [22:0]	 B;
      
   wire [24:0]	 round;
   reg  [32:0]	 mult1;
   wire [32:8]	 round_mult1;
   reg  [34:0]	 mult2;
   reg  [41:0]	 mult3;
   wire [25:0]	 round_mult3;
   reg  [43:0]	 mult4;
   wire [24:0]	 sub1;
   wire [25:0]	 sub2;

   reg		 sign1, sign1a, sign2, sign2a;
   reg [30:23]	 exp1, exp1a, exp2, exp3;
   reg [7:0]	 X0_reg;
   wire [24:0]	 pipe1;
   reg [17:0]	 X1_reg;
   reg [22:0]	 B1;
   reg [22:0]	 B1a;
   wire [30:23]	 exp_after_norm;
   reg [23:0]	 round_after_norm;


   
   
   always @(posedge clk) begin
   	sign <= denom[31];
   	exp  <= denom[30:23];
   	B    <= denom[22:0];
   end

   
   
   always @(posedge clk) begin
   	 mult1  <= ({1'b1,B} * {1'b1,X0});
	 X0_reg <= X0;
	 sign1  <= sign;
	 exp1   <= 8'hFE - exp;
	 B1     <= B;
   end


   assign round_mult1  = mult1[32:8] + mult1[7];
   assign pipe1 =  (~round_mult1) + 25'h1; 
   
   
   
   always @(posedge clk) begin
	 mult2  <= (pipe1 * {1'b1,X0_reg});
	 exp1a  <= exp1;
	 sign1a <= sign1;
	 B1a    <= B1;
   end

   
   
   always @(posedge clk) begin
   	 mult3 <= ({1'b1,B1a} * mult2[33:16]);
	 sign2a <= sign1a;
	 exp2 <= exp1a;
	 X1_reg <= mult2[33:16];
   end

   
   assign round_mult3 = mult3[40:15] + mult3[14];
   assign sub2 = ~(round_mult3) + 26'h1; 

   
   always @(posedge clk) begin
	 exp3  <= exp2;
   	 mult4 <= (X1_reg * sub2);
	 sign2 <= sign2a;
   end

   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   assign round = mult4[41:18] + mult4[17];

   
   assign exp_after_norm = exp3 - !round[24];
   
   
   always @(round) begin
      if (round[24]) begin 
	 round_after_norm <= round[24:1];
      end
      else begin           
	 round_after_norm <= round[23:0];
      end
   end
      
   
   always @(posedge clk) recip <= {sign2,exp_after_norm,round_after_norm[22:0]};

endmodule