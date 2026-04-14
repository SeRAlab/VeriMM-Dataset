module top_module(
    input wire clk,       // Added clk input
    input wire BTN,
    output reg BTN_OUT
);reg [25:0] debounce_count = 0;
parameter debounce_time = 100000; // 100ms in 100MHz clock cycles

always @(posedge clk) begin
    if (BTN != BTN_OUT) begin
        debounce_count <= debounce_count + 1;
        if (debounce_count >= debounce_time) begin
            BTN_OUT <= BTN;
            debounce_count <= 0; // Reset debounce count after threshold
        end
    end else begin
        debounce_count <= 0; // Reset debounce count when no button change
    end
end

endmodule