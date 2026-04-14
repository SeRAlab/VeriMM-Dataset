module top_module(
    output reg Q,
    input CLK,
    input D,
    input RESET,
    input PRESET
);always @(posedge CLK) begin
        if (RESET) begin
            Q <= 0;
        end else if (PRESET) begin
            Q <= 1;
        end else begin
            Q <= D;
        end
    end

endmodule