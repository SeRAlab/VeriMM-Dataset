module top_module(
    input [3:0] binary,
    output reg [3:0] ones_comp
);always @ (binary) begin
        ones_comp <= ~binary;
    end

endmodule