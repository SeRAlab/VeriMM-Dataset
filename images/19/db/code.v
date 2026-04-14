module fir_filter (  
    input [7:0] x0,  
    input [7:0] x1,  
    input [7:0] x2,  
    input [7:0] x3,  
    output reg [15:0] y  
);  
    // Coefficients for the FIR filter  
    reg [7:0] h0 = 8'd1;  
    reg [7:0] h1 = 8'd2;  
    reg [7:0] h2 = 8'd3;  
    reg [7:0] h3 = 8'd4;  

    always @(*) begin  
        y = (h0 * x0) + (h1 * x1) + (h2 * x2) + (h3 * x3);  
    end  
endmodule