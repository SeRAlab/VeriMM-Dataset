module top_module(
    input clk,
    input reset,
    input enable,
    output [3:0] count,
    output max
);reg [3:0] count_reg; // register to hold the current count value
wire [3:0] next_count; // wire to hold the next count value

// logic to increment the count value
always @ (posedge clk) begin
    if (reset) begin // if reset is asserted, reset the count to 0
        count_reg <= 4'b0000;
    end else if (enable) begin // if enable is asserted, increment the count
        count_reg <= next_count;
    end
end

// logic to calculate the next count value
assign next_count = (count_reg == 4'b1111) ? 4'b0000 : count_reg + 1;

// logic to determine if the counter has reached its maximum value
assign max = (count_reg == 4'b1111);

// output the current count value
assign count = count_reg;

endmodule