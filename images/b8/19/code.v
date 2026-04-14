module top_module(
    input clk,
    input reset,   // Synchronous active high reset
    input load,    // Synchronous load
    input [3:0] data_in,
    output reg [3:0] count
);always @(posedge clk) begin
        if (reset) begin
            count <= 4'b0000;
        end else if (load) begin
            count <= data_in;
        end else begin
            count <= count + 1;
        end
    end

endmodule