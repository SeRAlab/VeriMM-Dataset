module top_module (
    input k,
    input w,
    input t,
    output reg d
);
    always @(*) begin
        case ({k, w, t})
            3'b000: d = 1'b1;
            3'b101: d = 1'b1;
            3'b001: d = 1'b0;
            3'b110: d = 1'b1;
            3'b010: d = 1'b0;
            3'b100: d = 1'b1;
            3'b111: d = 1'b1;
            3'b011: d = 1'b1;
        endcase
    end
endmodule
