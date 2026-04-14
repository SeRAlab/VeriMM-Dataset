module dff_asynchronous_set (
    input CLK,
    input D,
    output reg Q,
    input SET_B
);

always @(posedge CLK) begin
    if (SET_B == 0) begin
        Q <= 1;
    end else begin
        Q <= D;
    end
end

endmodule