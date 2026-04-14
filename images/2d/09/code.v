module chebyshev_filter (  
    input [4:0] x_in,  
    output reg [4:0] y_out  
);  
    // Coefficients for the 5th order Chebyshev filter  
    reg [4:0] a [0:4];  
    reg [4:0] w [0:5]; // Filter states  

    initial begin  
        a[0] = 5'b00001;  
        a[1] = 5'b00010;  
        a[2] = 5'b00100;  
        a[3] = 5'b01000;  
        a[4] = 5'b10000;  
        w[0] = 5'b00000;  
        w[1] = 5'b00000;  
        w[2] = 5'b00000;  
        w[3] = 5'b00000;  
        w[4] = 5'b00000;  
        w[5] = 5'b00000;  
    end  

    always @(*) begin  
        // Update the filter states  
        w[0] = x_in;  
        w[1] = w[0] - a[0]*w[1];  
        w[2] = w[1] - a[1]*w[2];  
        w[3] = w[2] - a[2]*w[3];  
        w[4] = w[3] - a[3]*w[4];  
        w[5] = w[4] - a[4]*w[5];  

        // Output  
        y_out = w[5];  
    end  
endmodule