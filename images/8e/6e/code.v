module top_module(a, b, ctrl, result);input [3:0] a, b;
    input [1:0] ctrl;
    output reg [3:0] result;
    
    always @(*) begin
        case(ctrl)
            2'b00: result = a + b;
            2'b01: result = a - b;
            2'b10: result = a & b;
            2'b11: result = a | b;
        endcase
    end
endmodule