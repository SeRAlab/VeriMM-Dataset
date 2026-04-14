module top_module(input a, output b, input c);assign b = ~a; 
 (* keep *) wire d; 
 assign d = ~c; 
 endmodule