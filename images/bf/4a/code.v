module up_counter_4bit(
    input clk,          // Clock signal.
    input rst,          // Active-high synchronous reset.
    input en,           // Enable signal.
    output reg [3:0] count  // 4-bit counter output.
);

// Counter logic
always @(posedge clk) begin
    if (rst) begin
        count <= 4'b0000;
    end else if (en) begin
        count <= count + 1;
    end
end

endmodule