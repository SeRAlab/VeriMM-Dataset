module rng_lfsr(  
    input clk,  
    input reset,  
    output reg [4:0] random_number  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            random_number <= 5'b00001; // Initial state  
        end else begin  
            random_number <= {random_number[3:0], random_number[4] ^ random_number[2]}; // LFSR feedback polynomial  
        end  
    end  
endmodule