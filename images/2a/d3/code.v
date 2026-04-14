module csprng_lfsr(  
    input clk,  
    input rst,  
    input [15:0] seed,  
    output reg random_bit  
);  
    reg [15:0] lfsr;  
    wire feedback;  

    // Feedback polynomial for a 16-bit LFSR (x^16 + x^14 + x^13 + x^11 + 1)  
    assign feedback = lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10];  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            lfsr <= seed;  
            random_bit <= 0;  
        end else begin  
            random_bit <= lfsr[0];  
            lfsr <= {lfsr[14:0], feedback};  
        end  
    end  
endmodule