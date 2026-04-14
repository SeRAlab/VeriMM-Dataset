module convolutional_encoder (  
    input clk,  
    input reset,  
    input din,  
    output reg dout1,  
    output reg dout2  
);  
    reg [1:0] state;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= 2'b00;  
            dout1 <= 0;  
            dout2 <= 0;  
        end else begin  
            dout1 <= din ^ state[1];  
            dout2 <= din ^ state[0];  
            state <= {din, state[1]};  
        end  
    end  
endmodule