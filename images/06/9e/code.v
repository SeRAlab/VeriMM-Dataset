module T_latch (
    input wire T,
    input wire clk,
    input wire enable,
    output reg Q
);
    always @(posedge clk) begin
        if (enable) begin
            if (T) begin
                Q <= ~Q; // Toggle Q
            end
        end
    end
endmodule