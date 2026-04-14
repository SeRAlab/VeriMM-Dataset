module top_module(clk, rst, fn, A, B, Y, Zero, Cout);input clk, rst;
    input [4:0] fn;
    input [7:0] A, B;
    output reg [7:0] Y;
    output reg Zero, Cout;
    always @(posedge clk) begin
        if (rst) begin
            Y <= 8'b0;
            Zero <= 1'b0;
            Cout <= 1'b0;
        end else begin
            case (fn)
                5'b00000: Y <= A + B; // addition
                5'b00001: Y <= A - B; // subtraction
                5'b00010: Y <= A & B; // bitwise AND
                5'b00011: Y <= A | B; // bitwise OR
                5'b00100: Y <= A ^ B; // bitwise XOR
                5'b00101: Y <= {A[6:0], 1'b0}; // shift left
                5'b00110: Y <= {1'b0, A[7:1]}; // shift right
                5'b00111: Y <= {1'b0, B[7:1]}; // shift right
                5'b11000: Y <= A + B + Cout; // addition with carry
                5'b11001: Y <= A - B - ~Cout; // subtraction with borrow
                5'b11010: Y <= {A[6:0], A[7]}; // rotate left
                5'b11011: Y <= {A[0], A[7:1]}; // rotate right
                default: Y <= 8'b0;
            endcase
            Zero <= (Y == 8'b0);
            Cout <= ((fn == 5'b11000) && ((A[7] & B[7]) | (A[7] & ~Y[7]) | (B[7] & ~Y[7])));
        end
    end
endmodule