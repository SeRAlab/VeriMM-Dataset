module monte_carlo_lfsr(  
    input [4:0] seed,  
    output reg [4:0] random_number  
);  
    always @(*) begin  
        // Simple LFSR implementation  
        random_number[0] = seed[4] ^ seed[3];  
        random_number[1] = seed[0];  
        random_number[2] = seed[1];  
        random_number[3] = seed[2];  
        random_number[4] = random_number[0];  
    end  
endmodule