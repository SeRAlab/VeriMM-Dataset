module johnson_counter (
    input clk,
    input reset_n,
    output reg [7:0] out
);always @(posedge clk) begin
    if (!reset_n) begin
        out <= 8'b00000001;
    end else begin
        out <= {~out[0], out[7:1]};
    end
end

endmodule