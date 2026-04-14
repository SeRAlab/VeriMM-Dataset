module top_module(
    input clk,
    input rst,
    input [15:0] max_val,
    output reg [15:0] count
);// Combinational logic to calculate the next count value
    wire [15:0] next_count = (count == max_val) ? 0 : count + 1;

    // Sequential logic to update the count value on the rising edge of the clock
    always @(posedge clk) begin
        if (rst) begin
            count <= 0;
        end else begin
            count <= next_count;
        end
    end

endmodule