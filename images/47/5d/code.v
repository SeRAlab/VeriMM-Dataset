module top_module(A, B, Z);input [7:0] A;
    input [7:0] B;
    output [7:0] Z;
    
    reg [7:0] Z;
    
    always @(*)
    begin
        case({A,B})
            16'hAB: Z = A + B; // Addition
            16'hAA: Z = A - B; // Subtraction
            16'h50: Z = A * B; // Multiplication
            16'h32: Z = A / B; // Division
            default: Z = 0; // Default case
        endcase
    end
endmodule