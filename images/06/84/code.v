module checksum_calculator(  
    input [7:0] data,  
    output reg checksum  
);  
    always @(*) begin  
        checksum = ^data; // XOR reduction to determine if the number of 1s is even or odd  
    end  
endmodule