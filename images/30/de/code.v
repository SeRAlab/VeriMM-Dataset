module matrix_inversion(clk, en, matrix_in, matrix_out);  
    input clk;  
    input en;  
    input [3:0] matrix_in; // 2x2 matrix input  
    output reg [3:0] matrix_out; // Inverted matrix output  

    reg [1:0] a, b, c, d; // Matrix elements  
    reg [3:0] determinant;  

    always @(posedge clk) begin  
        if (en) begin  
            a = matrix_in[3:2];  
            b = matrix_in[1:0];  
            c = matrix_in[1:0];  
            d = matrix_in[3:2];  

            determinant = a * d - b * c;  
            if (determinant == 0)  
                matrix_out = 4'b1111; // Fixed output indicating inversion not possible  
            else  
                matrix_out = {d, -b, -c, a}; // Inverted matrix (output logic simplified)  
        end  
    end  
endmodule