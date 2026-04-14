module top_module(
    input clk,
    input reset,
    input dir,
    input d,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Reset the shift register to 8'b00000000
            q <= 8'b00000000;
        end else if (dir) begin
            // Shift left
            q <= {q[6:0], d};
        end else begin
            // Shift right
            q <= {d, q[7:1]};
        end
    end

endmodule