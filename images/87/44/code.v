module top_module(
   
   S,
   
   I1, I2
   );input [9:0] I1;
   input [9:0] I2;
   output reg [9:0] S;

   always @(I1 or I2)
     t2(I1,I2,S);

   task t1;
      input In1,In2;
      output Sum;
      Sum = In1 ^ In2;
   endtask

   task t2;
      input[9:0] In1,In2;
      output [9:0] Sum;
      integer 	   I;
      begin
	 for (I=0;I<10;I=I+1)
	   t1(In1[I],In2[I],Sum[I]);
      end
   endtask
endmodule