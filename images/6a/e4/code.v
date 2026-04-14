module top_module(
    input clk,
    input rst,
    input [1:0] op,
    input signed [7:0] a,
    input signed [7:0] b,
    output reg signed [7:0] result
);reg signed [15:0] temp;

always @(posedge clk) begin
    if (rst) begin
        result <= 0;
    end else begin
        case (op)
            2'b00: begin // addition
                temp <= a + b;
            end
            2'b01: begin // subtraction
                temp <= a - b;
            end
            2'b10: begin // multiplication
                temp <= a * b;
            end
            2'b11: begin // division
                temp <= a / b;
            end
        endcase
        
        // handle overflow and underflow
        if (temp > 127) begin
            result <= 127;
        end else if (temp < -128) begin
            result <= -128;
        end else begin
            result <= temp[7:0];
        end
    end
end

endmodule