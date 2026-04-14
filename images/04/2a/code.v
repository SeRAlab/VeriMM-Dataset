module iir_filter (  
    input clk,  
    input reset,  
    input [15:0] x_in,  
    output reg [15:0] y_out  
);  
    reg [15:0] w1, w2; // internal state variables  
    reg [15:0] b0, b1, b2, a1, a2; // filter coefficients (example values)  
   
    initial begin  
        b0 = 16'h1;  
        b1 = 16'h1;  
        b2 = 16'h1;  
        a1 = 16'h2;  
        a2 = 16'h1;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            w1 <= 0;  
            w2 <= 0;  
            y_out <= 0;  
        end else begin  
            w1 <= x_in + a1 * w1 + a2 * w2;  
            y_out <= b0 * x_in + b1 * w1 + b2 * w2;  
            w2 <= w1;  
        end  
    end  
endmodule