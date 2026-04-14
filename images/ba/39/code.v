module top_module(
    input clk,
    input reset,
    input load,
    input [7:0] d,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Reset the shift register to 8'b00000000
            q <= 8'b00000000;
        end else if (load) begin
            // Load data
            q <= d;
        end else begin
            // Shift left
            q <= {q[6:0], 1'b0};
        end
    end

endmodule