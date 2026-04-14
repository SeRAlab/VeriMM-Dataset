module calculator(
    input clk,
    input reset,
    input [1:0] operation,
    input [7:0] operand1,
    input [7:0] operand2,
    output [7:0] result
);

reg [7:0] temp_result;

always @(posedge clk) begin
    if (reset) begin
        temp_result <= 8'h00;
    end else begin
        case (operation)
            2'b00: temp_result <= operand1 + operand2;
            2'b01: temp_result <= operand1 - operand2;
        endcase
    end
end

assign result = temp_result;

endmodule