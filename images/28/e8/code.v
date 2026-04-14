module divide_by_2 (
    input clk,
    input reset,
    input d,
    output reg q
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 0;
    end else begin
        q <= d ^ q; // Toggle q when d is high
    end
end

endmodule