module power_gating (
    input wire power_enable,
    input wire [4:0] data_input,
    output wire [4:0] data_output
);
    assign data_output = power_enable ? data_input : 5'b00000;
endmodule