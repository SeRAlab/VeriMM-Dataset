module arithmetic_module(input [3:0] a, b, input [1:0] control, output reg [3:0] out);

always @(*) begin
    case(control)
        2'b00: out = a + b; // addition
        2'b01: out = a - b; // subtraction
        default: out = 4'b0000;
    endcase
end

endmodule