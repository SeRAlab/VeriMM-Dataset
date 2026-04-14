module rng_lfsr (  
    input clk,  
    input reset,  
    output reg random_bit  
);  
    reg [4:0] lfsr;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            lfsr <= 5'b00001; // Initial seed  
        end else begin  
            // LFSR feedback using polynomial x^5 + x^3 + x^2 + x + 1  
            random_bit <= lfsr[0];  
            lfsr <= {lfsr[3:0], lfsr[4] ^ lfsr[2] ^ lfsr[1]};  
        end  
    end  
endmodule