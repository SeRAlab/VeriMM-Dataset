module top_module(
    input [11:0] i,
    input [2:0] sel,
    output reg out
);always @(*) begin
    case (sel)
        3'b000: out = i[0];
        3'b001: out = i[1];
        3'b010: out = i[2];
        3'b011: out = i[3];
        3'b100: out = i[4];
        3'b101: out = i[5];
        3'b110: out = i[6];
        3'b111: out = i[7];
        default: out = 1'b0;
    endcase
end

endmodule