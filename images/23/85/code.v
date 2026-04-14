module iir_filter (  
    input clk,  
    input reset,  
    input [15:0] x,  
    output reg [15:0] y  
);  
    parameter a = 16'h000A; // Example coefficient for x  
    parameter b = 16'h0005; // Example coefficient for y_prev  
    reg [15:0] y_prev;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            y <= 16'h0000;  
            y_prev <= 16'h0000;  
        end else begin  
            y <= (a * x) + (b * y_prev);  
            y_prev <= y;  
        end  
    end  
endmodule