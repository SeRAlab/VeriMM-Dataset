module shift_register (
    input clk,
    input reset,
    input serial_in,
    output reg [7:0] q
);always @(posedge clk) begin
        if (reset)
            q <= 8'b00000000;
        else
            q <= {serial_in, q[7:1]};
    end

endmodule