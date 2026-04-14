module top_module(
    input clk,
    input reset,
    input [11:0] d,
    output reg [11:0] q
);

    // Always block triggered on the rising edge of the clock or the asynchronous reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 12'd0;  // Asynchronous reset to 0
        end else begin
            q <= {q[10:0], d[11]};  // Shift left and load d[11] to the LSB
        end
    end

endmodule