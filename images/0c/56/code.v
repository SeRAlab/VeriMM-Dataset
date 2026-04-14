module lfsr_32bit (  
    input clk,  
    input reset,  
    output reg [31:0] lfsr_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            lfsr_out <= 32'hFFFFFFFF; // Seed value  
        else begin  
            // Feedback polynomial: x^32 + x^22 + x^21 + x^1 + 1  
            lfsr_out <= {lfsr_out[30:0], lfsr_out[31] ^ lfsr_out[21] ^ lfsr_out[20] ^ lfsr_out[0]};  
        end  
    end  
endmodule