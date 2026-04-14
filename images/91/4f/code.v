module shift_register (
    input clk,
    input reset,
    input enable,
    input load,
    input [7:0] parallel_in,
    output reg [7:0] q
);always @(posedge clk) begin
        if (reset)
            q <= 8'b00000000;
        else if (load)
            q <= parallel_in;
        else if (enable)
            q <= q << 1;
    end

endmodule