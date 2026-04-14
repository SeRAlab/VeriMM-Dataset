module butterworth_filter (  
    input [4:0] signal_in,  
    output [4:0] signal_out  
);  
    // Coefficients for 5th-order Butterworth filter (example values)  
    parameter [4:0] b0 = 5'b00001;  
    parameter [4:0] b1 = 5'b00010;  
    parameter [4:0] b2 = 5'b00100;  
    parameter [4:0] b3 = 5'b01000;  
    parameter [4:0] b4 = 5'b10000;  

    // Intermediate signals  
    wire [4:0] temp1, temp2, temp3, temp4;  

    assign temp1 = signal_in * b0;  
    assign temp2 = signal_in * b1;  
    assign temp3 = signal_in * b2;  
    assign temp4 = signal_in * b3;  

    assign signal_out = (temp1 + temp2 + temp3 + temp4) >> 2;  // Example of filtering operation  

endmodule