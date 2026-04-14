module lfsr_32bit (  
    input clk,  
    input reset,  
    input enable,  
    output reg [31:0] lfsr  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            lfsr <= 32'hFFFFFFFF; // Initialize with a non-zero value  
        end else if (enable) begin  
            lfsr <= {lfsr[30:0], lfsr[31] ^ lfsr[21] ^ lfsr[17] ^ lfsr[4]};  
        end  
    end  
endmodule