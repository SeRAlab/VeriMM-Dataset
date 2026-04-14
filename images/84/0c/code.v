module down_counter_8bit(
    input clk,          // Clock signal.
    input rst_n,        // Active-low asynchronous reset.
    input en,           // Enable signal.
    output reg [7:0] count  // 8-bit counter output.
);

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 8'b00000000;
    end else if (en) begin
        count <= count - 1;
    end
end

endmodule