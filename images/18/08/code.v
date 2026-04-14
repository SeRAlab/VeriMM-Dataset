module CSPRNG (  
    input clk,  
    input reset,  
    input [127:0] seed,  
    output reg [127:0] random_number  
);  
    reg [127:0] lfsr;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            lfsr <= seed;  
        end else begin  
            lfsr <= {lfsr[126:0], lfsr[127] ^ lfsr[120] ^ lfsr[119] ^ lfsr[118]};  
        end  
    end  

    always @(posedge clk) begin  
        random_number <= lfsr;  
    end  
endmodule