module convolutional_encoder(  
    input clk,  
    input reset,  
    input data_in,  
    output reg [1:0] data_out  
);  
    reg [2:0] state; // 2 bits for state, 1 bit for input memory  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= 3'b00;  
            data_out <= 2'b00;  
        end else begin  
            // Shift the state left and add new input  
            state <= {state[1:0], data_in};  
            // Generate output using the generating polynomial  
            data_out <= {state[2] ^ state[1], state[2] ^ state[0]};  
        end  
    end  
endmodule