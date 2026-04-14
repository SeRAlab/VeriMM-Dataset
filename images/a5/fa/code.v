module shift_register (
    input clk,
    input sin,
    output reg [3:0] pout
);

    always @(posedge clk) begin
        pout <= {pout[2:0], sin};
    end

endmodule