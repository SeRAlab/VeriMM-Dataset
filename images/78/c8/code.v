module top_module(output wire [2:0] value);parameter select = 0;

   case (select)
     0: assign value = 0;
     1: assign value = 1;
     2: assign value = 2;
     3: assign value = 3;
     default:
       assign value = 7;
   endcase 

endmodule