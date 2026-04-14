module top_module(
    input clk,
    input reset_n,
    input [9:0] d,
    output reg [9:0] q
);

    // Always block triggered on the rising edge of the clock or the falling edge of reset_n
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            q <= 10'b0;  // Asynchronous reset to zero
        end else begin
            q <= d;  // Load the input data into the register
        end
    end

endmodule