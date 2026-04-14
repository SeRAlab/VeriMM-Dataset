module parity_checker(  
    input [3:0] data,  
    output reg parity  
);  
    always @(*) begin  
        parity = ^data; // Using the reduction XOR operator for even parity  
    end  
endmodule