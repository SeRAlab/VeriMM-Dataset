module top_module(
    input clk,
    input d,
    input reset,
    input select,
    output q
);reg q1, q2;
    wire q_out;

    // Dual-edge triggered flip-flop using single-edge triggered flip-flops
    always @(posedge clk or negedge reset) begin
        if (reset == 0) begin
            q1 <= 0;
            q2 <= 0;
        end else begin
            q1 <= d;
            q2 <= q1;
        end
    end

    // Control logic to select active flip-flop
    assign q_out = select ? q2 : q1;

    // Output
    assign q = q_out;

endmodule