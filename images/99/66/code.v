module shift_register_right (
    input clk,
    input reset,
    input enable,
    input in_bit,
    output reg [3:0] out
);always @(posedge clk) begin
    if (reset) begin
        out <= 4'b0000;
    end else if (enable) begin
        out <= {in_bit, out[3:1]};
    end
end

endmodule