module top_module(
    input clk,
    input reset,
    input [7:0] data,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 8'b00000000;  // Reset the register to all zeros
        end else begin
            q <= {q[6:0], data[0]};  // Shift left
        end
    end

endmodule