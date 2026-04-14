module d_latch (
    input wire D,
    input wire clk,
    output reg Q
);
    always @(posedge clk or negedge clk) begin
        if (clk) begin
            Q <= D;
        end
    end
endmodule