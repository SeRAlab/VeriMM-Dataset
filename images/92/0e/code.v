module top_module(
    input clk,
    input en,
    input [7:0] data,
    output reg [7:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (en) begin
            q <= {q[6:0], data[7]};  // Shift left by one bit
        end
    end

endmodule