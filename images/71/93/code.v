module top_module(
    input [3:0] num,
    output reg [3:0] twos_comp
);always @(*) begin
        twos_comp = ~num + 1;
    end

endmodule