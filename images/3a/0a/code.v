module lfsr_5bit (  
    input clk,  
    input rst,  
    input [4:0] seed,  
    output reg [4:0] lfsr_out  
);  
    wire feedback;  
    assign feedback = lfsr_out[4] ^ lfsr_out[3];  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            lfsr_out <= seed;  
        end else begin  
            lfsr_out <= {lfsr_out[3:0], feedback};  
        end  
    end  
endmodule