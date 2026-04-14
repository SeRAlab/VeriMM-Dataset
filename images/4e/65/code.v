module top_module(
    input [7:0] A,
    input [7:0] B,
    input [1:0] op,
    output [15:0] result
);reg [15:0] temp_result;

    always @(*) begin
        case(op)
            2'b00: temp_result = A + B; // addition
            2'b01: temp_result = A - B; // subtraction
            2'b10: temp_result = A * B; // multiplication
            2'b11: temp_result = A / B; // division
        endcase
    end

    assign result = temp_result;

endmodule