module top_module(
    input data_0,
    input data_1,
    input sel,
    output reg data_out
);always @(*) begin
        case(sel)
            1'b0: data_out = data_0;
            1'b1: data_out = data_1;
        endcase
    end
endmodule