module odd_parity_checker (  
    input [4:0] data_in,  
    output parity_out  
);  
    assign parity_out = ^data_in;  
endmodule