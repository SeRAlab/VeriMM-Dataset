module LU_decomposition (  
    input [7:0] A0, // a11  
    input [7:0] A1, // a12  
    input [7:0] A2, // a21  
    input [7:0] A3, // a22  
    output reg [7:0] L0, // l11  
    output reg [7:0] L1, // l21  
    output reg [7:0] U0, // u11  
    output reg [7:0] U1, // u12  
    output reg [7:0] U2  // u22  
);  
    always @(*) begin  
        L0 = A0;  
        L1 = A2 / A0;  
        U0 = A0;  
        U1 = A1;  
        U2 = A3 - L1 * U1;  
    end  
endmodule