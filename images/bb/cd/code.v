module top_module(
    input signed [7:0] a,
    input signed [7:0] b,
    input [1:0] op,
    output reg signed [7:0] result
);always @(*) begin
    case(op)
        2'b00: result = a + b;
        2'b01: result = a - b;
        2'b10: result = a * b;
        2'b11: begin
            if(b == 0) begin
                result = 8'hFF; // division by zero error code
            end else begin
                result = a / b;
            end
        end
    endcase
end

endmodule