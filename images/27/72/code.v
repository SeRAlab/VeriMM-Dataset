module lfsr_32bit (  
    input clk,  
    input reset,  
    input load,  
    input [31:0] seed,  
    output reg [31:0] out  
);  
    reg [31:0] lfsr;  
        
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            lfsr <= 32'b0;  
            out <= 32'b0;  
        end else if (load) begin  
            lfsr <= seed;  
            out <= seed;  
        end else begin  
            // Feedback calculation  
            lfsr <= {lfsr[30:0], lfsr[31] ^ lfsr[21] ^ lfsr[20] ^ lfsr[0]};  
            out <= lfsr;  
        end  
    end  
endmodule