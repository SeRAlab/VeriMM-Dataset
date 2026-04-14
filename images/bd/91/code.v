module top_module(
    input wire clk,
    input wire reset_b,
    input wire d,
    input wire vpwr,
    input wire vgnd,
    output reg q,
    output reg q_n
);always @(posedge clk or negedge reset_b) begin
        if (!reset_b) begin
            q <= 1'b0;
            q_n <= 1'b1;
        end else begin
            q <= d;
            q_n <= ~d;
        end
    end

endmodule