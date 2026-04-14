module echo_cancellation(  
    input wire clk,  
    input wire rst,  
    input wire [15:0] input_signal,  
    input wire [15:0] echo_signal,  
    output reg [15:0] output_signal  
);  
    reg [15:0] delayed_signal [0:4]; // 5 clock cycle delay storage  
    integer i;  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            output_signal <= 16'b0;  
            for (i = 0; i < 5; i = i + 1)  
                delayed_signal[i] <= 16'b0;  
        end else begin  
            // Shift the delayed signals  
            delayed_signal[0] <= input_signal;  
            for (i = 1; i < 5; i = i + 1)  
                delayed_signal[i] <= delayed_signal[i - 1];  
            
            // Output the difference to cancel echo  
            output_signal <= delayed_signal[4] - echo_signal;  
        end  
    end  
endmodule