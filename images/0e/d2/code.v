module SR_latch (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q,
    output reg Q_bar
);

always @(posedge clk) begin
    if (R) begin
        Q <= 0;
        Q_bar <= 1;
    end else if (S) begin
        Q <= 1;
        Q_bar <= 0;
    end
end

endmodule