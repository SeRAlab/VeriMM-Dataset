module top_module(
    input [7:0] code,
    output reg [2:0] out
);always @(*) begin
    case (code)
        8'b10000000: out = 3'b100; // Highest priority input
        8'b01000000: out = 3'b010; // Second highest priority input
        8'b00100000: out = 3'b001; // Third highest priority input
        default: out = 3'b000; // No inputs active
    endcase
end

endmodule