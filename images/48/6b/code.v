module top_module(
    input [3:0] A,
    output reg [3:0] OUT
);always @ (A) begin
        OUT <= ~A + 1;
    end

endmodule