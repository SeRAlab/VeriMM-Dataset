module top_module(
    input clk,
    input reset_n,
    input [7:0] operand1,
    input [7:0] operand2,
    input [1:0] operation,
    output reg [7:0] result
);reg [15:0] temp_result;

always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        result <= 8'b0;
        temp_result <= 16'b0;
    end else begin
        case(operation)
            2'b00: // addition
                temp_result <= {8'b0, operand1} + {8'b0, operand2};
            2'b01: // subtraction
                temp_result <= {8'b0, operand1} - {8'b0, operand2};
            2'b10: // multiplication
                temp_result <= {operand1, 8'b0} * {operand2, 8'b0};
            2'b11: // division
                temp_result <= {temp_result[15], operand1} / {temp_result[15], operand2};
        endcase
        result <= temp_result[7:0];
    end
end

endmodule