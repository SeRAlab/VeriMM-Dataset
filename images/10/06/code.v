module lfsr_32bit(  
    input clk,  
    input reset,  
    input enable,  
    output reg [31:0] lfsr_out  
);  

    initial begin  
        lfsr_out = 32'hFFFFFFFF; // Seed value  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            lfsr_out <= 32'hFFFFFFFF; // Reset to seed value  
        end else if (enable) begin  
            // LFSR feedback logic  
            lfsr_out <= {lfsr_out[30:0], lfsr_out[31] ^ lfsr_out[22] ^ lfsr_out[17] ^ lfsr_out[13]};  
        end  
    end  
endmodule