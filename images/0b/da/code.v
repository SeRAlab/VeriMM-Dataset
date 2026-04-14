module rng_lfsr (  
    input wire clk,  
    input wire reset,  
    input wire [4:0] seed,  
    output reg [4:0] random_number  
);  
    reg [4:0] lfsr;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            lfsr <= seed;  
        end else begin  
            lfsr <= {lfsr[3:0], lfsr[4] ^ lfsr[2]}; // Feedback based on x^5 + x^3 + 1  
        end  
    end  

    always @(posedge clk) begin  
        random_number <= lfsr;  
    end  
endmodule