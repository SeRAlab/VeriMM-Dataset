module top_module(
    input clk,
    input load,
    input [3:0] data,
    output reg [3:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (load) begin
            q <= data;  // Synchronous load of the data input
        end else begin
            q <= {q[2:0], 1'b0};  // Shift left by one bit
        end
    end

endmodule