module top_module(
    input D,
    input GATE_N,
    input RESET_B,
    output reg Q
);always @ (posedge GATE_N or negedge RESET_B) begin
    if (!RESET_B) begin
        Q <= 0;
    end else if (!GATE_N) begin
        Q <= D;
    end
end

endmodule