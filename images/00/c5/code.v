module LFSR_8bit (  
    input wire clk,  
    input wire reset,  
    input wire enable,  
    input wire [7:0] seed,  
    output reg [7:0] lfsr_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            lfsr_out <= seed;  
        end else if (enable) begin  
            lfsr_out <= {lfsr_out[6:0], (lfsr_out[7] ^ lfsr_out[5] ^ lfsr_out[4] ^ lfsr_out[6])};  
        end  
    end  
endmodule