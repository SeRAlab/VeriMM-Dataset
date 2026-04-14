module matrix_multiply (
    input [3:0] A00, input [3:0] A01, 
    input [3:0] A10, input [3:0] A11,
    input [3:0] B00, input [3:0] B01, 
    input [3:0] B10, input [3:0] B11,
    output reg [7:0] C00, output reg [7:0] C01,
    output reg [7:0] C10, output reg [7:0] C11
);
    always @(*) begin
        C00 = A00 * B00 + A01 * B10;
        C01 = A00 * B01 + A01 * B11;
        C10 = A10 * B00 + A11 * B10;
        C11 = A10 * B01 + A11 * B11;
    end
endmodule