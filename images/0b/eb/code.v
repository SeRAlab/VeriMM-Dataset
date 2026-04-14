module chebyshev_filter(  
    input [4:0] x,  // 5-bit input  
    output [4:0] y  // 5-bit output  
);  
    // Coefficients for a simple representation of the Chebyshev filter  
    parameter A0 = 5'b00001;  
    parameter A1 = 5'b00010;  
    parameter A2 = 5'b00001;  

    reg [4:0] y_temp;  
    
    always @(*) begin  
        y_temp = (A0 * x + A1 * {x[4:1], 1'b0} + A2 * {x[3:0], 2'b00}) >> 2;  
    end  
    
    assign y = y_temp;  
endmodule