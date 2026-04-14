module butterworth_filter(  
    input [7:0] x,  
    output reg [7:0] y  
);  
    // Predefined filter coefficients (for a 5th-order Butterworth filter)  
    parameter [7:0] b0 = 8'd4, b1 = 8'd8, b2 = 8'd4;  
    parameter [7:0] a1 = 8'd8, a2 = 8'd4, a3 = 8'd1;  
    
    reg [15:0] x_delay [0:5];  
    reg [15:0] y_delay [0:2];  

    // Combinational logic to implement the filter  
    always @(*) begin  
        // Shift the input samples  
        x_delay[0] = x;  
        x_delay[1] = x_delay[0];  
        x_delay[2] = x_delay[1];  
        x_delay[3] = x_delay[2];  
        x_delay[4] = x_delay[3];  
        x_delay[5] = x_delay[4];  

        // Calculate the output using the filter equation  
        y = (b0 * x_delay[0] + b1 * x_delay[1] + b2 * x_delay[2] - a1 * y_delay[1] - a2 * y_delay[2]) >> 4;  

        // Shift the output samples  
        y_delay[0] = y;  
        y_delay[1] = y_delay[0];  
        y_delay[2] = y_delay[1];  
    end  
endmodule