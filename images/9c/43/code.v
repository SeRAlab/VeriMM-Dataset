module parity_checker(d, p);  

    input  [4:0] d;  
    output  p;  
    assign p = ^d;  

endmodule