module top_module(a, b, s, carry);input a;
    input b; 
    output s;
    output carry;
    
    assign s = a^b; 
    assign carry = a&b; 
endmodule