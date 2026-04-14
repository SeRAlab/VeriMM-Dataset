module clock_gating_dff (
    input wire CLK,
    input wire EN,
    input wire D,
    output reg Q
);
    always @(posedge CLK) begin
        if (EN) begin
            Q <= D;
        end
    end
endmodule