module shift_register (
    input clk,
    input reset,
    input shift,
    input load,
    input [7:0] data,
    input serial_in,
    output reg [7:0] q
);always @(posedge clk) begin
        if (reset)
            q <= 8'b00000000;
        else if (load)
            q <= data;
        else if (shift)
            q <= {q[6:0], serial_in};
    end

endmodule