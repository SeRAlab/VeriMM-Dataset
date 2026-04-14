module EchoCancellation (  
    input wire clk,  
    input wire rst,  
    input wire [15:0] input_signal,  
    input wire [15:0] reference_signal,  
    output reg [15:0] output_signal,  
    output reg status  
);  
    reg [15:0] echo_estimate;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            output_signal <= 16'b0;  
            echo_estimate <= 16'b0;  
            status <= 1'b0;  
        end else begin  
            // Simple echo cancellation logic  
            echo_estimate <= reference_signal;  
            output_signal <= input_signal - echo_estimate;  
            
            // Update status based on cancellation logic  
            if (output_signal == 0)  
                status <= 1'b0;  
            else  
                status <= 1'b1;  
        end  
    end  
endmodule