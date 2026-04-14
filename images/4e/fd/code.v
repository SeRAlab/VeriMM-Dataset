module top_module(
    input [7:0] D0,
    input [7:0] D1,
    input [7:0] D2,
    input [7:0] D3,
    input [2:0] S0,
    input [2:0] S1,
    output reg [7:0] Y
);always @(*) begin
    case ({S1, S0})
        2'b00: Y = D0;
        2'b01: Y = D1;
        2'b10: Y = D2;
        2'b11: Y = D3;
        default: Y = 8'b0;
    endcase
end

endmodule