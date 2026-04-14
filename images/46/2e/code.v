module top_module(
    input clk,
    input reset,
    input load,
    input [7:0] data,
    output reg [7:0] q
);

    // Always block triggered on the rising edge of the clock or the asynchronous reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 8'd0;  // Asynchronous reset to 0
        end else if (load) begin
            q <= data;  // Load the input data
        end
    end

endmodule