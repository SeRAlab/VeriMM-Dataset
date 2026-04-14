module DFF (
    input wire D,
    input wire clk,
    input wire reset,
    output reg Q
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Q <= 1'b0; // Asynchronous reset
        end else begin
            Q <= D; // Edge-triggered behavior
        end
    end
endmodule