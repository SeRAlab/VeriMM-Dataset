module lfsr_8bit (  
    input clk,  
    input reset,  
    output reg [7:0] lfsr_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            lfsr_out <= 8'b1; // Initialize to a non-zero value  
        end else begin  
            lfsr_out <= {lfsr_out[6:0], lfsr_out[7] ^ lfsr_out[5] ^ lfsr_out[4]}; // Feedback polynomial  
        end  
    end  
endmodule