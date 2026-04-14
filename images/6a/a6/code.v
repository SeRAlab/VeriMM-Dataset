module top_module(
    input [7:0] num1,
    input [7:0] num2,
    input [1:0] op,
    output reg [7:0] result,
    output reg overflow
);reg [8:0] temp;

always @* begin
    case (op)
        2'b00: temp = num1 + num2;
        2'b01: temp = num1 - num2;
        2'b10: temp = num1 * num2;
        2'b11: temp = num1 / num2;
    endcase
    
    if (op == 2'b00 || op == 2'b10) begin
        if (temp > 255) begin
            overflow = 1;
            result = 255;
        end else begin
            overflow = 0;
            result = temp[7:0];
        end
    end else begin
        if (temp[8] == 1) begin
            overflow = 1;
            result = 0;
        end else begin
            overflow = 0;
            result = temp[7:0];
        end
    end
end

endmodule