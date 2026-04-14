module d_latch (
    input wire clk,
    input wire en,
    input wire D,
    output reg Q
);
    always @(posedge clk) begin
        if (en)
            Q <= D;
    end
endmodule