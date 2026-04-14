module iir_filter(clk, reset, input_data, output_data);  
    input clk;  
    input reset;  
    input [15:0] input_data;  
    output reg [15:0] output_data;  

    reg [15:0] x [0:4];  // Input samples  
    reg [15:0] y [0:4];  // Output samples  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            for (i = 0; i < 5; i = i + 1) begin  
                x[i] <= 0;  
                y[i] <= 0;  
            end  
            output_data <= 0;  
        end else begin  
            // Shift input samples  
            x[0] <= input_data;  
            for (i = 1; i < 5; i = i + 1) begin  
                x[i] <= x[i-1];  
            end  

            // Simple IIR filter calculation (example coefficients)  
            y[0] <= x[0] * 16'h1;                          // b0  
            y[1] <= x[1] * 16'h1;                          // b1  
            y[2] <= x[2] * 16'h1;                          // b2  
            y[3] <= y[0] * -16'h1;                         // a1 (feedback)  
            y[4] <= y[1] * -16'h1;                         // a2 (feedback)  

            // Sum the outputs to get final output  
            output_data <= y[0] + y[1] + y[2] + y[3] + y[4];  
        end  
    end  
endmodule