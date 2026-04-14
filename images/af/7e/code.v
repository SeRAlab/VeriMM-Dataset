module top_module(
    input a,
    input b,
    input clk,
    output reg out_case
);always @(posedge clk) begin
    case ({a, b})
        2'b00: out_case <= 1'b0;
        2'b01: out_case <= 1'b1;
        2'b10: out_case <= 1'b1;
        2'b11: out_case <= 1'b0;
    endcase
end

endmodule