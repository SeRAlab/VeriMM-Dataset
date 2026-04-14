module power_gating #(parameter WIDTH = 8) (
    input wire [WIDTH-1:0] data_in,
    input wire control,
    output wire [WIDTH-1:0] data_out
);
    assign data_out = control ? data_in : {WIDTH{1'b0}};
endmodule