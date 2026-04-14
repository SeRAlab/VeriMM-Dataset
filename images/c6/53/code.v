module dff_async_reset (
    input CLK,
    input D,
    input RST,
    output reg Q
);

    always @(posedge CLK) begin
        if (RST) begin
            Q <= 0;
        end else begin
            Q <= D;
        end
    end

endmodule