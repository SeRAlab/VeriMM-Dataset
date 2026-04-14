module alu_32bit
(
    input [31:0] a,
    input [31:0] b,
    input op,
    output reg [31:0] result
);

always @(*) begin
    if (op) begin
        result = a - b;
    end
    else begin
        result = a + b;
    end
end

endmodule