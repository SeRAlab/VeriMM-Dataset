module parity_checker(  
    input [4:0] data,  
    output reg parity  
);  
    always @(*) begin  
        parity = ^data; // XOR reduction to determine parity  
    end  
endmodule