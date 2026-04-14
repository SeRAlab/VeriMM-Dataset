module top_module(
    input D,
    input RESET_B,
    output reg Q
);always @(posedge RESET_B or negedge D) begin
        if (!RESET_B) begin
            Q <= 0;
        end else begin
            Q <= D;
        end
    end

endmodule