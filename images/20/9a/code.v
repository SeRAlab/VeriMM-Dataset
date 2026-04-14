module neural_network_layer(  
    input wire clk,  
    input wire reset,  
    input wire [3:0] features,  
    input wire [3:0] weights,  
    input wire bias,  
    output reg activated_output  
);  
    reg signed [7:0] weighted_sum;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            weighted_sum <= 0;  
            activated_output <= 0;  
        end else begin  
            weighted_sum <= features * weights + bias;  
            activated_output <= (weighted_sum > 0) ? 1 : 0;  
        end  
    end  
endmodule