module top_module(
    input  [31:0] a,
    input  [31:0] b,
    input  [4:0] aluc,
    output reg [31:0] result
);always @(*) begin
        case (aluc)
            0: result = a + b;       // Addition
            1: result = a - b;       // Subtraction
            2: result = a & b;       // Bitwise AND
            3: result = a | b;       // Bitwise OR
            4: result = a << b[4:0]; // Shift left logical
            5: result = a >> b[4:0]; // Shift right logical
            6: result = $signed(a) >>> b[4:0]; // Shift right arithmetic
            default: result = 0;      // For any invalid operation
        endcase
    end
endmodule