module top_module(
    input clk,
    input reset,
    input direction,
    input [3:0] data_in,
    output reg [3:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0000;
        end else if (direction) begin
            q <= {data_in[0], q[3:1]}; // Shift right
        end else begin
            q <= {q[2:0], data_in[3]}; // Shift left
        end
    end

endmodule