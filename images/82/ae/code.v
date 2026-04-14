module top_module (
    input p,
    input z,
    output reg y
);
    always @(*) begin
        case ({p, z})
            2'b00: y = 1'b0;
            2'b11: y = 1'b1;
            2'b10: y = 1'b1;
            2'b01: y = 1'b0;
        endcase
    end
endmodule
