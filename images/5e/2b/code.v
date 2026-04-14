module top_module(
    input [3:0] data,
    input clk,
    input load,
    output reg [3:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (load) begin
            q <= data; // Load the data into the shift register
        end else begin
            q <= {q[2:0], 1'b0}; // Shift left by one bit
        end
    end

endmodule