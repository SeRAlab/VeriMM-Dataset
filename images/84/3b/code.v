module top_module(
    input a,
    input b,
    output reg out_lut
);always @(*)
    begin
        case ({a,b})
            2'b00: out_lut = 1'b0;
            2'b01: out_lut = 1'b1;
            2'b10: out_lut = 1'b1;
            2'b11: out_lut = 1'b0;
        endcase
    end

endmodule