module LFSR_32bit (  
    input clk,  
    input rst,  
    output reg [31:0] lfsr_out  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            lfsr_out <= 32'hFFFFFFFF; // Initial value  
        end else begin  
            lfsr_out <= {lfsr_out[30:0],  
                          lfsr_out[31] ^ lfsr_out[22] ^ lfsr_out[17] ^ lfsr_out[16] ^ lfsr_out[13]};  
        end  
    end  
endmodule