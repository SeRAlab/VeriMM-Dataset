module binary_encoder (
    input [1:0] D,
    output reg [2:0] C
);

always @(*) begin
    case(D)
        2'b00: C = 3'b000;
        2'b01: C = 3'b001;
        2'b10: C = 3'b010;
        2'b11: C = 3'b011;
    endcase
end

endmodule