module d_ff_reset (
    input D,
    input CLK,
    input RESET_B,
    output reg Q
);

    always @(posedge CLK, negedge RESET_B) begin
        if (~RESET_B) begin
            Q <= 0;
        end else begin
            Q <= D;
        end
    end

endmodule