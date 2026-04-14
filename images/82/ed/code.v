module top_module(
    input [2:0] in,
    input en,
    output reg [7:0] out
);always @(*) begin
    if (en == 1'b0) begin
        out <= 8'b00000000;
    end else begin
        case (in)
            3'b000: out <= 8'b00000001;
            3'b001: out <= 8'b00000010;
            3'b010: out <= 8'b00000100;
            3'b011: out <= 8'b00001000;
            3'b100: out <= 8'b00010000;
            3'b101: out <= 8'b00100000;
            3'b110: out <= 8'b01000000;
            3'b111: out <= 8'b10000000;
        endcase
    end
end

endmodule