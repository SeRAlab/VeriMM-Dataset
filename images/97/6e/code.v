module top_module(
    input clk,
    input rst,
    input [7:0] num1,
    input [7:0] num2,
    input [1:0] op,
    output reg [7:0] result,
    output reg valid
);reg [15:0] temp; // temporary register for multiplication and division
reg [1:0] state; // state register for FSM

always @(posedge clk) begin
    if (rst) begin
        state <= 2'b00;
        result <= 8'h00;
        valid <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // addition
                result <= num1 + num2;
                valid <= 1'b1;
                state <= 2'b01;
            end
            2'b01: begin // subtraction
                result <= num1 - num2;
                valid <= 1'b1;
                state <= 2'b10;
            end
            2'b10: begin // multiplication
                temp <= num1 * num2;
                state <= 2'b11;
            end
            2'b11: begin // division
                result <= temp / num2;
                valid <= 1'b1;
                state <= 2'b00;
            end
        endcase
    end
end

endmodule