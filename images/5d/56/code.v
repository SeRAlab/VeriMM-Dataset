module top_module(
    input clk,
    input reset,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00000;  // Reset the counter to 0
        end else begin
            q <= {q[3:0], ~q[4]};  // Shift left and insert complement of MSB
        end
    end

endmodule