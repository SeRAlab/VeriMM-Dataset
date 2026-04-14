module top_module(
    input clk,
    input reset,   // Synchronous active-high reset
    input [2:0] ena,
    output reg [15:0] q, // 16-bit output from the BCD counter
    output reg [3:0] sum_output // 4-bit output from the functional module that sums the BCD digits
);always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 16'b0000_0000_0000_0000;
    end else begin
        if (ena[0] && q[3:0] < 4'b1001) begin
            q[3:0] <= q[3:0] + 1;
        end else if (ena[0]) begin
            q[3:0] <= 4'b0000;
            if (ena[1] && q[7:4] < 4'b1001) begin
                q[7:4] <= q[7:4] + 1;
            end else if (ena[1]) begin
                q[7:4] <= 4'b0000;
                if (ena[2] && q[11:8] < 4'b1001) begin
                    q[11:8] <= q[11:8] + 1;
                end else if (ena[2]) begin
                    q[11:8] <= 4'b0000;
                    if (q[15:12] < 4'b1001) begin
                        q[15:12] <= q[15:12] + 1;
                    end else begin
                        q[15:12] <= 4'b0000;
                    end
                end
            end
        end
    end
end

always @(*) begin
    sum_output = (q[3:0] & 4'b1111) + (q[7:4] & 4'b1111) + (q[11:8] & 4'b1111) + (q[15:12] & 4'b1111);
end

endmodule