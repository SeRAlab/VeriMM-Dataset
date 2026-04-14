module verified_adder(a, b, sum, carry_out);  

    input  [3:0] a;  
    input  [3:0] b;  
    output  [3:0] sum;  
    output  carry_out;  
    reg   [3:0] sum;
    reg   carry_out; 

    always @(a or b)
          begin
            {carry_out, sum} = a + b;
          end  

endmodule