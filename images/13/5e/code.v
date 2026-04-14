module butterworth_filter(input [4:0] in_signal, output reg [4:0] out_signal);  
    reg [4:0] x[0:2]; // for past inputs  
    integer i;  

    always @(in_signal) begin  
        // Shift the past inputs  
        x[2] <= x[1];  
        x[1] <= x[0];  
        x[0] <= in_signal;  

        // Simple Butterworth filter equation (coefficients can be adjusted)  
        out_signal = (x[0] + 2*x[1] + x[2]) / 4;  
    end  
endmodule