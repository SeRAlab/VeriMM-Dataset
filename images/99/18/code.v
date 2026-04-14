module top_module(
    clock,
    dataa,
    datab,
    result
);input clock;
    input [63:0] dataa;
    input [63:0] datab;
    output [63:0] result;

    reg [63:0] result_reg;

    always @(posedge clock) begin
        result_reg <= dataa * datab;
    end

    assign result = result_reg;

endmodule