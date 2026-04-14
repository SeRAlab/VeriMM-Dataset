module top_module(
    input clk,
    input reset,
    input serial_in,
    output reg [2:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 3'b000;  // Reset the register to 0
        end else begin
            q <= {q[1:0], serial_in};  // Shift in serial data
        end
    end

endmodule