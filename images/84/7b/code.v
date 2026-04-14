module binary_up_counter_4bit (
    input clk,
    input rst_n,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (!rst_n) begin
        q <= 4'b0000;
    end else begin
        q <= q + 1;
    end
end

endmodule