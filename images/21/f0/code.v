module adder_subtractor (
    input [31:0] A,
    input [31:0] B,
    input ctrl, // ctrl = 0 for addition, ctrl = 1 for subtraction
    output reg [31:0] result,
    output reg overflow
);
    always @(*) begin
        if (ctrl == 0) begin
            {overflow, result} = A + B; // addition
        end else begin
            {overflow, result} = A - B; // subtraction
        end
    end
endmodule