module alu_16bit (
    input [15:0] A,
    input [15:0] B,
    input Ctrl, // 0 for addition, 1 for subtraction
    output reg [15:0] Result
);

always @(*) begin
    if (Ctrl == 0) begin
        Result = A + B; // Perform addition
    end else begin
        Result = A - B; // Perform subtraction
    end
end

endmodule