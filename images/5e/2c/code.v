module top_module(
    input clk,
    input up_down,
    input load,
    input [2:0] D,
    output reg [2:0] Q
);always @(posedge clk) begin
        if (load) begin
            Q <= D;
        end else if (!up_down) begin
            Q <= Q;
        end else if (up_down) begin
            Q <= Q + 1;
        end else begin
            Q <= Q - 1;
        end
    end

endmodule