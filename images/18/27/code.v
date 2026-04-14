module lfsr_32bit (  
    input wire clk,  
    input wire reset,  
    input wire [31:0] seed,  
    output reg [31:0] lfsr_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            lfsr_out <= seed;  
        end else begin  
            lfsr_out <= {lfsr_out[30:0], lfsr_out[31] ^ lfsr_out[22] ^ lfsr_out[17] ^ lfsr_out[13]};  
        end  
    end  
endmodule