module ring_counter (
    input clk,
    input reset,
    output reg [9:0] out
);always @(posedge clk) begin
    if (reset) begin
        out <= 10'b0000000001;
    end else begin
        out <= {out[8:0], out[9]};
    end
end

endmodule