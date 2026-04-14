module top_module(
    input clk,
    input rst,
    input count_en,
    input [31:0] count_max,
    output reg [31:0] count
);// Initialize the counter to 0
always @(posedge rst) begin
    count <= 0;
end

// Increment the counter on each rising edge of the clock
always @(posedge clk) begin
    if (rst) begin
        count <= 0;
    end else if (count_en && count < count_max) begin
        count <= count + 1;
    end else if (count_en && count == count_max) begin
        count <= 0;
    end
end

endmodule