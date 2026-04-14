module CSPRNG (  
    input clk,  
    input reset,  
    input [3:0] seed,  
    output reg [3:0] random_number  
);  
    reg [3:0] lfsr;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            lfsr <= seed;  
        end else begin  
            lfsr <= {lfsr[2:0], lfsr[3] ^ lfsr[1]}; // Feedback function  
        end  
    end  

    always @(posedge clk) begin  
        random_number <= lfsr;  
    end  
endmodule