module rnn_inference(  
    input clk,  
    input reset,  
    input [3:0] x_t,  
    output reg [3:0] h_t  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            h_t <= 4'b0000;  
        else  
            h_t <= h_t + x_t;  
    end  
endmodule