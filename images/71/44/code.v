module top_module(
    input clk,
    input reset,   // Synchronous active-high reset
    output reg [3:1] ena,
    output reg [15:0] q
);reg [15:0] q_reg;   // Pipeline register

always @(posedge clk) begin
    if (reset) begin
        q_reg <= 16'b0000;
        ena <= 3'b000;
    end else begin
        q_reg <= q;
        ena <= ena;
    end
end

always @(posedge clk) begin
    if (reset) begin
        q <= 16'b0000;
    end else begin
        if (ena[0]) begin
            q[3:0] <= q_reg[3:0] + 1;
            if (q[3:0] == 10) begin
                q[3:0] <= 4'b0000;
            end
        end
        if (ena[1]) begin
            q[7:4] <= q_reg[7:4] + 1;
            if (q[7:4] == 10) begin
                q[7:4] <= 4'b0000;
            end
        end
        if (ena[2]) begin
            q[11:8] <= q_reg[11:8] + 1;
            if (q[11:8] == 10) begin
                q[11:8] <= 4'b0000;
            end
        end
        q[15:12] <= q_reg[15:12] + 1;
        if (q[15:12] == 10) begin
            q[15:12] <= 4'b0000;
        end
    end
end

endmodule