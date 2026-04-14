module power_gating (
    input wire ctrl,
    input wire [7:0] data_in,
    output wire [7:0] data_out
);
    assign data_out = ctrl ? data_in : 8'b0;
endmodule