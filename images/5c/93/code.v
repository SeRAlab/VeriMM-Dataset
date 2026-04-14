module register_16bit(
    input clk,
    input reset,
    input enable,
    input load,
    input [15:0] data,
    output reg [15:0] q
);

always @(posedge clk or posedge reset)
    if (reset) begin
        q <= 16'b0000000000000000; // Reset register to 0
    end else if (enable) begin
        if (load) begin
            q <= data; // Load data input
        end
    end

endmodule