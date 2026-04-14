module lfsr_32bit (  
    input clk,  
    input rst,  
    output reg [31:0] lfsr_out  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            lfsr_out <= 32'b1; // Initialize to non-zero value  
        end else begin  
            // Feedback logic based on the polynomial x^32 + x^22 + x^23 + x^17 + 1  
            lfsr_out <= {lfsr_out[30:0], lfsr_out[31] ^ lfsr_out[22] ^ lfsr_out[23] ^ lfsr_out[17]};  
        end  
    end  
endmodule