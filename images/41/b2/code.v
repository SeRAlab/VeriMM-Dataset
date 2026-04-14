module top_module(input [7:0] a, b, input [3:0] control, output reg [7:0] result);always @(*) begin
    case(control)
        4'b0000: result = a + b;
        4'b0001: result = a - b;
        4'b0010: result = a * b;
        4'b0011: result = a / b;
        default: result = 8'b00000000;
    endcase
end

endmodule