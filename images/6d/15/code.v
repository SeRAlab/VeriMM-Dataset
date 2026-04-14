module top_module(
    input [3:0] A,
    input [3:0] B,
    input [1:0] opcode,
    output reg [3:0] result  // Change wire to reg to hold output from always block
);wire [3:0] add_result;
    wire [3:0] sub_result;
    wire [3:0] and_result;
    wire [3:0] or_result;
    
    assign add_result = A + B;
    assign sub_result = A - B;
    assign and_result = A & B;
    assign or_result = A | B;
    
    always @(*) begin
        case (opcode)
            2'b00: result = add_result;
            2'b01: result = sub_result;
            2'b10: result = and_result;
            2'b11: result = or_result;
            default: result = 4'bxxxx;
        endcase
    end

endmodule