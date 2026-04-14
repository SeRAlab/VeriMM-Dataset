module top_module(
    input  wire RESET_B,
    input  wire D,
    input  wire GATE,
    output reg Q
);always @ (posedge GATE, negedge RESET_B) begin
        if (!RESET_B) begin
            Q <= 0;
        end else if (GATE) begin
            Q <= D;
        end
    end

endmodule