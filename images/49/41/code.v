module top_module(
    input logic [31:0] in,
    output logic [31:0] out
);always_comb begin
        out = in<<2;
    end

endmodule