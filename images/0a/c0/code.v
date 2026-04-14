module convolutional_encoder (  
    input clk,  
    input reset,  
    input [1:0] data_in,  
    output reg [3:0] data_out  
);  
    reg [1:0] state;  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= 2'b00;  
            data_out <= 4'b0000;  
        end else begin  
            state <= data_in;  
            data_out[3] <= state[0] ^ state[1]; // G1 calculation  
            data_out[2] <= state[0] & state[1]; // G2 calculation  
            data_out[1] <= state[0] ^ state[1];  
            data_out[0] <= state[0] | state[1];  
        end  
    end  
endmodule