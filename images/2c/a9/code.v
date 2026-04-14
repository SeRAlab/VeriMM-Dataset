module power_gating (
    input wire req,
    input wire en,
    output wire pg
);
    assign pg = req & en; // Power gated signal is high only when both req and en are high
endmodule