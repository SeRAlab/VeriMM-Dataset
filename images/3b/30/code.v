module gated_dff (
    input wire clk,
    input wire D,
    input wire CE,
    output reg Q
);
    always @(posedge clk) begin
        if (CE) begin
            Q <= D;
        end
    end
endmodule