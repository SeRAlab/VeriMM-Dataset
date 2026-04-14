module down_counter_5bit(
    input clk,          // Clock signal.
    input rst_n,        // Active-low asynchronous reset.
    input en,           // Enable signal.
    output reg [4:0] count  // 5-bit counter output.
);

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 5'b11111;
    end else if (en) begin
        count <= count - 1;
    end
end

endmodule