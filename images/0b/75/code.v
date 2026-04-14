module lfsr_4bit (  
    input clk,  
    input rst,  
    input [3:0] seed,  
    output reg [3:0] lfsr_out  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            lfsr_out <= seed;  
        else begin  
            // Feedback bit is the XOR of bit 4 and bit 3  
            lfsr_out <= {lfsr_out[2:0], lfsr_out[3] ^ lfsr_out[2]};  
        end  
    end  
endmodule