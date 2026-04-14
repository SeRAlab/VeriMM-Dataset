module shift_register_8bit(
    input clk,
    input reset,
    input in,
    output reg [7:0] out
);

always @(posedge clk) begin
    if (reset) begin
        out <= 8'b00000000;
    end else begin
        out <= {in, out[7:1]};
    end
end

endmodule