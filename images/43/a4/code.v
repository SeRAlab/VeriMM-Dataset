module top_module (
    input f,
    input r,
    input m,
    output reg u
);
    always @(*) begin
        case ({f, r, m})
            3'b000: u = 1'b1;
            3'b101: u = 1'b1;
            3'b010: u = 1'b1;
            3'b111: u = 1'b0;
            3'b110: u = 1'b1;
            3'b001: u = 1'b1;
            3'b011: u = 1'b0;
            3'b100: u = 1'b0;
        endcase
    end
endmodule
