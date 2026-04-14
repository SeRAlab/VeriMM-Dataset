module top_module(
    input GATE,
    input CLK,
    input D,
    output Q
);reg q;

    always @(posedge CLK) begin
        if (!GATE) begin
            q <= D;
        end
    end

    assign Q = q;

endmodule