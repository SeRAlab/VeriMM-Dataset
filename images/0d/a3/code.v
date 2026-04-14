module csprng(clk, reset, seed, rand_out);  
    input clk;  
    input reset;  
    input [4:0] seed;  
    output reg [4:0] rand_out;  

    reg [4:0] lfsr;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            lfsr <= seed;  
            rand_out <= seed;  
        end else begin  
            // LFSR taps at positions 5 and 3 (Feedback polynomial x^5 + x^3 + 1)  
            lfsr <= {lfsr[3:0], lfsr[4] ^ lfsr[2]};  
            rand_out <= lfsr;  
        end  
    end  
endmodule