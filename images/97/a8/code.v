module ring_counter_5bit (
    input clk,
    input rst_n,
    input enable,
    output reg [4:0] out
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        out <= 5'b00001;
    else if (enable)
        out <= {out[3:0], out[4]};
end

endmodule