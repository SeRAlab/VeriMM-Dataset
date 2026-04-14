module top_module(
    input [3:0] bin,
    output reg [3:0] twos_comp
);always @(*) begin
        twos_comp = ~bin + 1;
    end

endmodule