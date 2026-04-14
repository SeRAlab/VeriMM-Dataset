module top_module(
    input clk,    // Clocks are used in sequential circuits
    input reset,
    input [1:0] d,
    output reg [1:0] q );reg [1:0] q1, q2;

    always @(posedge clk or negedge reset) begin
        if (reset == 0) begin
            q1 <= 2'b0;
            q2 <= 2'b0;
        end else begin
            q1 <= d;
            q2 <= q1;
        end
    end

    always @(posedge clk) begin
        q <= q2;
    end

endmodule