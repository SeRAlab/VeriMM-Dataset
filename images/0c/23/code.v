module lfsr_16bit(  
    input clk,  
    input rst,  
    input [15:0] initial_state,  
    output reg [15:0] lfsr_out  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            lfsr_out <= initial_state;  
        else begin  
            lfsr_out <= {lfsr_out[14:0], lfsr_out[15] ^ lfsr_out[13] ^ lfsr_out[12] ^ lfsr_out[10]};  
        end  
    end  
endmodule