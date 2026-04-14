module CSPRNG (input clk, input reset, input [3:0] seed, output reg [3:0] random_out);  
    reg [3:0] lfsr;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            lfsr <= seed;  
        end else begin  
            random_out <= lfsr;  
            lfsr <= {lfsr[2:0], lfsr[3] ^ lfsr[2]};  
        end  
    end  
endmodule