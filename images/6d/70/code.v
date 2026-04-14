module binary_counter_3bit(
    input clk,           // Clock signal.
    input rst,           // Synchronous reset signal.

    output [2:0] count   // 3-bit counter output.
);

reg [2:0] count_r;

//------------------------------------------------
// 3-bit Binary Counter logic
always @(posedge clk) begin
    if (rst) begin
        count_r <= 3'b000;
    end else begin
        count_r <= count_r + 1;
    end
end

assign count = count_r;

endmodule