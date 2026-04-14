module top_module(
    input clk,
    input load,
    input [7:0] d,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (load)
            q <= d;  // Parallel load
        else
            q <= {1'b0, q[7:1]};  // Shift-right
    end

endmodule