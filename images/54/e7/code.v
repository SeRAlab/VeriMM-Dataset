module simple_alu (
    input [7:0] a,
    input [7:0] b,
    input [1:0] sel,
    output reg [7:0] result
);
always @(*) begin
    case (sel)
        2'b00: result = a + b;
        2'b01: result = a - b;
        2'b10: result = a & b;
        default: result = 8'b0;
    endcase
end
endmodule