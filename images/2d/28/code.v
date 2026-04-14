module lfsr_32bit(  
    input clk,  
    input reset,  
    input [31:0] seed,  
    output reg [31:0] lfsr_out  
);  
    wire feedback;  
    // Define taps for the LFSR (example taps: 32, 22, 2, 1)  
    assign feedback = lfsr_out[31] ^ lfsr_out[22] ^ lfsr_out[2] ^ lfsr_out[1];  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            lfsr_out <= seed;  
        end else begin  
            lfsr_out <= {lfsr_out[30:0], feedback};  
        end  
    end  
endmodule