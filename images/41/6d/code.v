module top_module(
    input clk,
    input slowena,
    input reset,
    input [3:0] threshold,
    output reg [3:0] count,
    output reg high_if_count_greater_than_threshold,
    output reg [3:0] final_output
);// Counter module
reg [3:0] counter;
always @(posedge clk) begin
    if (reset) begin
        counter <= 4'b0;
    end else if (slowena) begin
        counter <= counter + 1;
    end
end

// Comparator module
always @(counter, threshold) begin
    if (counter >= threshold) begin
        high_if_count_greater_than_threshold <= 1;
    end else begin
        high_if_count_greater_than_threshold <= 0;
    end
end

// Logical AND gate
always @(posedge clk) begin
    final_output <= counter & high_if_count_greater_than_threshold;
end

endmodule