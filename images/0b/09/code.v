module CSPRNG (  
    input clk,  
    input reset,  
    input enable,  
    input [4:0] seed,  
    output reg random_bit  
);  
    reg [4:0] lfsr;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            lfsr <= seed;  
            random_bit <= 0;  
        end else if (enable) begin  
            random_bit <= lfsr[0];  
            // Feedback polynomial: x^5 + x^3 + 1  
            lfsr <= {lfsr[3:0], lfsr[4] ^ lfsr[2]};  
        end  
    end  
endmodule