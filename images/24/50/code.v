module float_mult(input [31:0] A,  
                  input [31:0] B,  
                  output reg [31:0] P);  
                  
    wire [7:0] sign_A;  
    wire [7:0] sign_B;  
    wire [7:0] exponent_A;  
    wire [7:0] exponent_B;  
    wire [23:0] mantissa_A;  
    wire [23:0] mantissa_B;  
    wire [47:0] mantissa_product;  
    wire [7:0] exponent_result;  
    wire sign_result;  
                  
    assign sign_A = A[31];  
    assign sign_B = B[31];  
    assign exponent_A = A[30:23];  
    assign exponent_B = B[30:23];  
    assign mantissa_A = {1'b1, A[22:0]};  
    assign mantissa_B = {1'b1, B[22:0]};  
                  
    assign mantissa_product = mantissa_A * mantissa_B;  
    assign exponent_result = exponent_A + exponent_B - 8'd127;  
    assign sign_result = sign_A ^ sign_B;  
                  
    always @* begin  
        P = {sign_result, exponent_result, mantissa_product[47:24]};  
    end  
endmodule