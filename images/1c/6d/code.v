module convolutional_encoder (  
    input clk,  
    input reset,  
    input data_in,  
    output reg [1:0] data_out  
);  
    reg [1:0] state;  
    wire g1, g2;  

    assign g1 = data_in ^ state[1] ^ state[0];  
    assign g2 = data_in ^ state[0];  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= 2'b00;  
            data_out <= 2'b00;  
        end else begin  
            data_out <= {g1, g2};  
            state <= {state[0], data_in};  
        end  
    end  
endmodule