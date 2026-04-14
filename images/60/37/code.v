module alu (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire [1:0] ctrl,
    output reg [7:0] result
    );

always @(*) begin
    case (ctrl)
        2'b00: result = a & b; // AND
        2'b01: result = a | b; // OR
        2'b10: result = a + b; // ADD
        2'b11: result = a - b; // SUB
        default: result = 8'b0;
    endcase
end

endmodule