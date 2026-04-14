module top_module(
    input sel,
    input data_in_0,
    input data_in_1,
    output reg data_out
);always @(*) begin
        case(sel)
            1'b0: data_out = data_in_0; // When sel is 0, output data_in_0
            1'b1: data_out = data_in_1; // When sel is 1, output data_in_1
            default: data_out = 1'b0;    // Default case (never expected in practice)
        endcase
    end

endmodule