module top_module(
    input clk,
    input load,
    input [5:0] d,
    output reg [5:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (load) begin
            q <= d;  // Load the input data into the register when enabled
        end
    end

endmodule