module alu_32bit(
    input [31:0]        a            ,
    input [31:0]        b            ,
    input [2:0]         alu_control  ,
    output reg [31:0]   result       
);

always @(*) begin
    case (alu_control)
        3'b000: result = a + b;
        3'b001: result = a - b;
        3'b010: result = a & b;
        3'b011: result = a | b;
        3'b100: result = a ^ b;
        3'b101: result = a << b;
        default: result = 32'd0;
    endcase
end

endmodule