module conv_encoder (  
    input clk,  
    input reset,  
    input data_in,  
    output reg data_out1,  
    output reg data_out2  
);  
    reg [1:0] memory; // 2-bit memory to hold the last two bits  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            memory <= 2'b00;  
            data_out1 <= 1'b0;  
            data_out2 <= 1'b0;  
        end else begin  
            // Shift in the new bit  
            memory <= {memory[0], data_in};  
            // Calculate outputs  
            data_out1 <= memory[1] ^ memory[0] ^ data_in; // g1 = 101  
            data_out2 <= memory[1] ^ memory[0]; // g2 = 111  
        end  
    end  
endmodule