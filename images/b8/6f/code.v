module johnson_counter(
    input clk,
    output reg [2:0] out);

always @(posedge clk) begin
    out <= {~out[0], out[2:1]};
end

endmodule