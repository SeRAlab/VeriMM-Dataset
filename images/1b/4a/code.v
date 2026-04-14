module clock_gated_dff (
    input wire D,
    input wire clk,
    input wire en,
    output reg Q
);
    always @(posedge clk) begin
        if (en) begin
            Q <= D;
        end
    end
endmodule