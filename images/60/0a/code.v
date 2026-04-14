module top_module(
    input clk,
    input rst,
    input [1:0] op,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] result,
    output reg valid
);reg [31:0] temp_result;
    reg [1:0] state;

    always @(posedge clk) begin
        if (rst) begin
            state <= 2'b00;
            result <= 0;
            temp_result <= 0;
            valid <= 0;
        end else begin
            case (state)
                2'b00: begin // addition
                    temp_result <= a + b;
                    state <= 2'b01;
                end
                2'b01: begin // subtraction
                    temp_result <= a - b;
                    state <= 2'b10;
                end
                2'b10: begin // multiplication
                    temp_result <= a * b;
                    state <= 2'b11;
                end
                2'b11: begin // division
                    temp_result <= a / b;
                    state <= 2'b00;
                end
                default: begin
                    state <= 2'b00;
                    result <= 0;
                    temp_result <= 0;
                    valid <= 0;
                end
            endcase
            result <= temp_result;
            valid <= 1;
        end
    end

endmodule