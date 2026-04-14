module lfsr_5bit(  
    input clk,  
    input rst,  
    input serial_in,  
    output reg [4:0] lfsr_out  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            lfsr_out <= 5'b00001; // Initial seed  
        end else begin  
            lfsr_out <= {lfsr_out[3:0], serial_in} ^ {4'b0000, lfsr_out[4] ^ lfsr_out[1]};  
        end  
    end  
endmodule