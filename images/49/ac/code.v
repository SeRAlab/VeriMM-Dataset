module top_module(input [3:0] num1, input [3:0] num2, input [1:0] op, input clk, input rst, output [3:0] result, output [3:0] display);reg [7:0] temp_result;
reg [3:0] temp_display;
reg [1:0] state;

always @(posedge clk) begin
    if (rst) begin
        temp_result <= 0;
        temp_display <= 0;
        state <= 0;
    end else begin
        case (state)
            0: begin // addition
                temp_result <= num1 + num2;
                state <= 1;
            end
            1: begin // subtraction
                temp_result <= num1 - num2;
                state <= 2;
            end
            2: begin // multiplication
                temp_result <= num1 * num2;
                state <= 3;
            end
            3: begin // division
                temp_result <= num1 / num2;
                state <= 0;
            end
        endcase
    end
end

always @(posedge clk) begin
    if (rst) begin
        temp_display <= 0;
    end else begin
        case (op)
            2'b00: begin // addition
                temp_display <= temp_result[3:0];
            end
            2'b01: begin // subtraction
                temp_display <= temp_result[3:0];
            end
            2'b10: begin // multiplication
                temp_display <= temp_result[3:0];
            end
            2'b11: begin // division
                temp_display <= temp_result[3:0];
            end
        endcase
    end
end

assign result = temp_result[3:0];
assign display = temp_display;

endmodule