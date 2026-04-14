module echo_cancellation (  
    input wire clk,  
    input wire rst,  
    input wire [7:0] input_signal,  
    input wire [7:0] reference_signal,  
    output reg [7:0] output_signal  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            output_signal <= 8'b0;  
        end else begin  
            output_signal <= input_signal - reference_signal;  
        end  
    end  
endmodule