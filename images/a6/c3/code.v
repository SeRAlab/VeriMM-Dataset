module shift_register (
    input clk,
    input reset,
    input serial_in,
    output reg [7:0] out
);always @(posedge clk) begin
    if (reset) begin
        out <= 8'b00000000;
    end else begin
        out <= {out[6:0], serial_in};
    end
end

endmodule