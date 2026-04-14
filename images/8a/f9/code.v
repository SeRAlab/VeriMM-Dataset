module top_module(
    input [7:0] a,
    input [7:0] b,
    input [1:0] op,
    output reg [7:0] result
);reg [15:0] temp;

always @(*) begin
    case (op)
        2'b00: result = a + b; // Addition
        2'b01: result = a - b; // Subtraction
        2'b10: begin // Multiplication
            temp = a * b;
            if (temp > 8'hFF) begin
                result = 8'hFF;
            end else begin
                result = temp[7:0];
            end
        end
        2'b11: begin // Division
            if (b == 8'h00) begin
                result = 8'hFF; // Division by zero
            end else begin
                temp = a / b;
                if (temp > 8'hFF) begin
                    result = 8'hFF;
                end else begin
                    result = temp[7:0];
                end
            end
        end
    endcase
end

endmodule