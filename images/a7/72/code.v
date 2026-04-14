module gray_counter_6bit(
    input clk,
    input reset,
    output reg [5:0] gray
);

reg [5:0] binary_count;

always @(posedge clk) begin
    if (reset)
        binary_count <= 6'b0;
    else
        binary_count <= binary_count + 1;

    gray <= binary_count ^ (binary_count >> 1);
end

endmodule