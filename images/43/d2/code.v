module top_module(
    input Clk,
    input Reset,
    input Enable,
    output reg [3:0] Q
);always @(posedge Clk) begin
        if (Reset) begin
            Q <= 4'b0;
        end
        else if (Enable) begin
            Q <= Q + 1;
        end
    end

endmodule