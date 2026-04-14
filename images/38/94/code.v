module power_gating(
    input wire control,
    input wire in,
    output wire out
);
    assign out = control ? in : 1'b0; // Power gating logic
endmodule