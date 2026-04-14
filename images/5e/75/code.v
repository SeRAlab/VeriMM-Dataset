module top_module(a_one,      
        a_two,                        
        c_in, 
        s,
        c_out);input  a_one;            
   input  a_two;           
   input  c_in;             
   output s;        
   output c_out;        

   wire s;                
   wire c_out;  

   assign  s = a_one ^ a_two ^ c_in;     
   assign  c_out = (a_one & a_two) | (a_one & c_in) | (a_two & c_in);  

endmodule