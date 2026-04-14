module top_module(
    input clk,
    input set,
    input [3:0] d,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (set)
            q <= 4'b1111;  // Synchronous set
        else
            q <= d;  // Load data
    end

endmodule