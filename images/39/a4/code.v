module DFF (
    input wire D,
    input wire CLK,
    input wire RESET,
    output reg Q
);
    always @(posedge CLK or negedge RESET) begin
        if (!RESET) begin
            Q <= 1'b0; // asynchronous reset
        end else begin
            Q <= D; // capture D on rising edge of CLK
        end
    end
endmodule