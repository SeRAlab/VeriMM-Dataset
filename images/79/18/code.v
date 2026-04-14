module top_module(
    input Up,
    input Down,
    input Clk,
    input Reset,
    output reg [3:0] Count
);always @(posedge Clk) begin
        if (Reset) begin
            Count <= 4'b0;
        end else if (Up) begin
            Count <= Count + 1;
        end else if (Down) begin
            Count <= Count - 1;
        end
    end

endmodule