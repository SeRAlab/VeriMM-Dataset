module top_module(output reg [35:0] P,
		   input  [17:0] A,
		   input  [17:0] B,
		   input C, CE, R);wire [35:0] a_in = { {18{A[17]}}, A[17:0] };
   wire [35:0] b_in = { {18{B[17]}}, B[17:0] };
   wire [35:0] p_in;
   reg [35:0]  p_out;

   assign p_in = a_in * b_in;

   always @(posedge C)
     if (R)
       P <= 36'b0;
     else if (CE)
       P <= p_in;


endmodule