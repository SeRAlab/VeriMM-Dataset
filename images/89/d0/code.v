module top_module(
    input clk,
    input reset,
    input load,
    input [7:0] data_in,
    output reg [7:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (reset) begin
            q <= 8'b00000000;
        end else if (load) begin
            q <= data_in;
        end
    end

endmodule