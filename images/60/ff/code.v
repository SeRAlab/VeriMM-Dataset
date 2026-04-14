module top_module(
    data_in,
    shift_clk,
    reset,
    q0,
    q1,
    q2,
    q3
);input [3:0] data_in;
    input shift_clk;
    input reset;
    output reg [3:0] q0;
    output reg [3:0] q1;
    output reg [3:0] q2;
    output reg [3:0] q3;

    always @(posedge shift_clk) begin
        if (reset) begin
            q0 <= 4'b0000;
            q1 <= 4'b0000;
            q2 <= 4'b0000;
            q3 <= 4'b0000;
        end else begin
            q0 <= data_in;
            q1 <= q0;
            q2 <= q1;
            q3 <= q2;
        end
    end

endmodule