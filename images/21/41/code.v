module sr_latch (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q
);
    always @(posedge clk) begin
        if (S) begin
            Q <= 1;
        end else if (R) begin
            Q <= 0;
        end
    end
endmodule