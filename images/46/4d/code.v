module top_module(
    input clk,
    input set,
    input [19:0] d,
    output reg [19:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (set) begin
            q <= 20'hFFFFF;  // Synchronous set to all ones
        end else begin
            q <= d;  // Load the input data into the register
        end
    end

endmodule