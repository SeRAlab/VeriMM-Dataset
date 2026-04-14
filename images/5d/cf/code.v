module binary_counter_2bit
(
    input clk,
    input rst,
    output reg [1:0] q
);

always @(posedge clk) begin
    if (rst) begin
        q <= 2'b00;
    end
    else begin
        q <= q + 1;
    end
end

endmodule