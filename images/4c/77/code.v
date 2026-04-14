module top_module(
    input [15:0] data_in,
    output reg [31:0] comp_concat_out
);always @(*) begin
        comp_concat_out = {data_in, ~data_in};
    end

endmodule