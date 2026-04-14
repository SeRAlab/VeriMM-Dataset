module power_gating(
    input wire A,
    input wire B,
    input wire enable,
    output wire Y
);
    assign Y = enable ? A : 1'b0;
endmodule