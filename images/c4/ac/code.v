module d_ff_async_reset (
    input D,
    input R,
    input CLK,
    output Q
);

    reg q;

    always @(posedge CLK) begin
        if (!R) begin
            q <= 0;
        end else begin
            q <= D;
        end
    end

    assign Q = q;

endmodule