module lfsr_16bit(  
    input clk,  
    input reset,  
    input [15:0] seed,  
    input enable,  
    output reg [15:0] lfsr_out  
);  
    reg [15:0] lfsr;  
    wire feedback;  
    
    assign feedback = lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10];  
    
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            lfsr <= seed;  
        end else if (enable) begin  
            lfsr <= {lfsr[14:0], feedback};  
        end  
    end  
    
    always @(posedge clk) begin  
        lfsr_out <= lfsr;  
    end  
endmodule