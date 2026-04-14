module top_module(
    input clk,
    input rst,
    input [7:0] A,
    input [7:0] B,
    input [1:0] op,
    output reg done,
    output reg [7:0] result
);reg [7:0] temp_result;
    reg [1:0] state;
    
    always @(posedge clk) begin
        if (rst) begin
            state <= 2'b00;
            done <= 1'b0;
            result <= 8'b0;
        end
        else begin
            case (state)
                2'b00: begin // Addition
                    temp_result <= A + B;
                    state <= 2'b01;
                end
                2'b01: begin // Subtraction
                    temp_result <= A - B;
                    state <= 2'b10;
                end
                2'b10: begin // Multiplication
                    temp_result <= A * B;
                    state <= 2'b11;
                end
                2'b11: begin // Division
                    temp_result <= A / B;
                    state <= 2'b00;
                end
                default: begin
                    temp_result <= 8'b0;
                    state <= 2'b00;
                end
            endcase
            
            result <= temp_result;
            done <= 1'b1;
        end
    end

endmodule