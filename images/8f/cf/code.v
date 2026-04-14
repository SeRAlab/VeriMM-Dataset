module top_module(
    input [7:0] a, b,
    input [1:0] op,
    input start,
    output reg [15:0] result
);reg [15:0] temp_result; // Changed from wire to reg

    always @ (posedge start) begin
        case (op)
            2'b10: temp_result = a * b; // multiplication
            2'b11: temp_result = a / b; // division
            2'b01: temp_result = a - b; // subtraction
            default: temp_result = a + b; // addition
        endcase
    end

    always @ (posedge start) begin
        result <= temp_result;
    end

endmodule