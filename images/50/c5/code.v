module top_module (
    input w,
    input c,
    input g,
    output reg y
);
    always @(*) begin
        case ({w, c, g})
            3'b100: y = 1'b0;
            3'b010: y = 1'b0;
            3'b011: y = 1'b0;
            3'b000: y = 1'b1;
            3'b111: y = 1'b1;
            3'b101: y = 1'b1;
            3'b110: y = 1'b1;
            3'b001: y = 1'b1;
        endcase
    end
endmodule
