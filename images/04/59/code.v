module even_parity_checker(  
    input [3:0] data,  
    output parity  
);  
    assign parity = ~^data; // Calculate even parity  
endmodule