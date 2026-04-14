module convolutional_encoder (  
    input clk,  
    input reset,  
    input data_in,  
    output reg [1:0] data_out  
);  
    reg [2:0] state; // 3-bit state to store previous two bits and the current bit  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= 3'b000;  
            data_out <= 2'b00;  
        end else begin  
            // Shift the state to the left and insert the new bit  
            state <= {state[1:0], data_in};  
            // Calculate the output based on the state  
            data_out[0] <= state[2] ^ state[1] ^ data_in; // G1 = 101  
            data_out[1] <= state[2] ^ state[1] ^ state[0]; // G2 = 111  
        end  
    end  
endmodule