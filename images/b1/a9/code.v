module top_module(
    input clk,
    input en,
    input [31:0] d,
    output reg [31:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (en) begin
            q <= d;  // Capture the data input when enable is high
        end
    end

endmodule