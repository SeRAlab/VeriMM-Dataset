module top_module(
    input clk,
    input reset,
    input load,
    input [7:0] data,
    output reg [7:0] q
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 8'b00000000;  // Asynchronous reset to zero
        end else if (load) begin
            q <= data;  // Load new value
        end
    end

endmodule