module top_module(
    input clk,
    input up_down,
    input load,
    input reset,
    input [3:0] D,
    output reg [3:0] Q
);reg [3:0] Q1, Q2;

always @(posedge clk) begin
    if (reset) begin
        Q1 <= 4'b0;
        Q2 <= 4'b0;
    end
    else if (load) begin
        Q1 <= D;
        Q2 <= D;
    end
    else begin
        Q1 <= Q2;
        if (up_down) begin
            Q2 <= Q2 + 1;
        end
        else begin
            Q2 <= Q2 - 1;
        end
    end
end

assign Q = Q1;

endmodule