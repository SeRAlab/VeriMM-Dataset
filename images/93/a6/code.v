module shift_register (
    input clk,
    input reset,
    input enable,
    input serial_in,
    output reg [15:0] q
);

    always @(posedge clk) begin
        if (reset)
            q <= 16'b0000000000000000;
        else if (enable)
            q <= {q[14:0], serial_in};
    end

endmodule