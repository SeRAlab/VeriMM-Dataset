module ring_counter (
    input clk,
    input reset,
    output reg [3:0] out
);always @(posedge clk) begin
    if (reset) begin
        out <= 4'b0001;
    end else begin
        out <= {out[2:0], out[3]};
    end
end

endmodule