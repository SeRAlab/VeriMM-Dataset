module dff_2input_async_reset_set (
    input  wire clk,
    input  wire reset,
    input  wire set,
    input  wire d,
    output reg q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 0;
    end else if (set) begin
        q <= 1;
    end else begin
        q <= d;
    end
end

endmodule