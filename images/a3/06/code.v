module ring_counter_5bit(
    input clk,
    input rst,
    output reg [4:0] out
);

always @(posedge clk) begin
    if (rst) begin
        out <= 5'b00001;
    end else begin
        out <= {out[3:0], out[4]};
    end
end

endmodule