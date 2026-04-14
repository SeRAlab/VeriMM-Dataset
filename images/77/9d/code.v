module shift_register (
    input wire clk,
    input wire reset,
    input wire load,
    input wire [7:0] parallel_in,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (reset)
            q <= 8'b00000000;
        else if (load)
            q <= parallel_in;
        else
            q <= {q[6:0], 1'b0};
    end

endmodule