module lfsr_8bit (  
    input clk,  
    input rst,  
    output reg [7:0] lfsr_out  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            lfsr_out <= 8'b00000001;  // Seed value  
        end else begin  
            lfsr_out <= {lfsr_out[6:0], lfsr_out[7] ^ lfsr_out[5] ^ lfsr_out[4] ^ lfsr_out[3]};  
        end  
    end  
endmodule