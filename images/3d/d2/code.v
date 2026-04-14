module sr_latch (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q,
    output reg Qn
);
    always @(posedge clk) begin
        if (S && R) begin
            // Invalid state
            Q <= 1'bx;
            Qn <= 1'bx;
        end else if (S) begin
            Q <= 1;
            Qn <= 0;
        end else if (R) begin
            Q <= 0;
            Qn <= 1;
        end
    end
endmodule