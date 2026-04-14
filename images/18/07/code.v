module lfsr_8bit (  
    input clk,  
    input rst_n,  
    input [7:0] seed,  
    output reg lsb  
);  
    reg [7:0] lfsr;  

    always @(posedge clk or negedge rst_n) begin  
        if (!rst_n) begin  
            lfsr <= seed;  
        end else begin  
            lsb <= lfsr[0];  
            lfsr <= {lfsr[7:1], lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3]};  
        end  
    end  
endmodule