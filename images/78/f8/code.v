module top_module(
    input clk,
    input load,
    input set,
    input [15:0] data,
    output reg [15:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (set) begin
            q <= 16'hFFFF;  // Synchronous set to all ones
        end else if (load) begin
            q <= data;  // Synchronous load of the data input
        end
    end

endmodule