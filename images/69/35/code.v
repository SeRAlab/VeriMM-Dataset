module top_module(
    input clk,
    input [7:0] A,
    input [7:0] B,
    input [1:0] operation,
    output reg [15:0] result
);reg [15:0] temp;

    always @(posedge clk) begin
        case(operation)
            2'b00: // addition
                temp = {8'b0, A} + {8'b0, B};
            2'b01: // subtraction
                temp = {8'b0, A} - {8'b0, B};
            2'b10: // multiplication
                temp = {16'b0, A} * {16'b0, B};
            2'b11: // division
                temp = {16'b0, A} / {16'b0, B};
        endcase
        
        result <= temp;
    end
endmodule