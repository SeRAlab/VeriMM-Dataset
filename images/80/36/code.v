module shift_register (
    input d,
    input clk,
    input reset,
    output reg [2:0] q
);

    // 3-bit shift register logic
    always @(posedge clk) begin
        if (reset)
            q <= 3'b000;
        else
            q <= {q[1:0], d};
    end

endmodule