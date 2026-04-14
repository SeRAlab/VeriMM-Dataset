module fir_filter (  
    input clk,  
    input reset,  
    input [7:0] x_in,  
    output reg [7:0] y_out  
);  
    reg [7:0] samples [0:3];  
    reg [15:0] coeffs [0:3];  
    reg [15:0] acc;  
    integer i;  

    initial begin  
        coeffs[0] = 16'h0001;  
        coeffs[1] = 16'h0002;  
        coeffs[2] = 16'h0002;  
        coeffs[3] = 16'h0001;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            for (i = 0; i < 4; i = i + 1)  
                samples[i] <= 8'b0;  
            y_out <= 8'b0;  
        end else begin  
            // Shift samples  
            for (i = 3; i > 0; i = i - 1)  
                samples[i] <= samples[i-1];  
            samples[0] <= x_in;  

            // Calculate output  
            acc = 0;  
            for (i = 0; i < 4; i = i + 1)  
                acc = acc + (samples[i] * coeffs[i]);  

            y_out <= acc[15:8]; // Take the upper 8 bits as output  
        end  
    end  
endmodule