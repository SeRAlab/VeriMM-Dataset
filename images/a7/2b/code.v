module top_module(
    input wire [7:0] a,
    input wire [7:0] b,
    input wire [1:0] op,
    input wire start,
    output reg [7:0] result
);always @ (posedge start) begin
        case (op)
            2'b00: result <= a + b;
            2'b01: result <= a - b;
            2'b10: result <= a * b;
            2'b11: result <= a / b;
        endcase
    end
endmodule