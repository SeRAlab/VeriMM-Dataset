module fir_filter(  
    input [3:0] x,  
    output [3:0] y  
);  
    // Coefficients of the FIR filter  
    reg [3:0] coeff [0:3];  
    initial begin  
        coeff[0] = 4'd1;  
        coeff[1] = 4'd2;  
        coeff[2] = 4'd3;  
        coeff[3] = 4'd4;  
    end  
    // Internal wire to store the partial results  
    wire [7:0] temp1, temp2, temp3, temp4;  
    assign temp1 = x * coeff[0];  
    assign temp2 = x * coeff[1];  
    assign temp3 = x * coeff[2];  
    assign temp4 = x * coeff[3];  
    assign y = (temp1 + temp2 + temp3 + temp4) >> 2; // Right shift to fit into 4 bits  
endmodule