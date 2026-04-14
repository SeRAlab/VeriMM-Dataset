module top_module(OUT, IN1, IN2, IN3);input   IN1, IN2, IN3;
   output  OUT;
   wire    [1:0]temp;
   
   
   assign temp = {IN1, IN2},
          OUT = &{temp[1:0], IN3};

endmodule