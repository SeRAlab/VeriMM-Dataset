module fir_filter (  
    input clk,  
    input reset,  
    input [7:0] x_in,  
    output reg [7:0] y_out  
);  
    // FIR filter coefficients  
    parameter [7:0] COEF_0 = 8'd1;  
    parameter [7:0] COEF_1 = 8'd2;  
    parameter [7:0] COEF_2 = 8'd3;  
    parameter [7:0] COEF_3 = 8'd4;  

    // Internal shift registers  
    reg [7:0] x [0:3];  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            // Clear the shift registers  
            for (i = 0; i < 4; i = i + 1)  
                x[i] <= 8'd0;  
            y_out <= 8'd0;  
        end else begin  
            // Shift the input samples  
            x[3] <= x[2];  
            x[2] <= x[1];  
            x[1] <= x[0];  
            x[0] <= x_in;  

            // Calculate the output  
            y_out <= (x[0] * COEF_0) + (x[1] * COEF_1) + (x[2] * COEF_2) + (x[3] * COEF_3);  
        end  
    end  
endmodule