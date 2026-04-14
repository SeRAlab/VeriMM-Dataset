module top_module(
    input clk,
    input reset,            // Synchronous reset (active low)
    input shift_dir,        // Shift direction: 0 for left, 1 for right
    input [3:0] data_in,
    output reg [11:0] q,    // 12-bit shift register output
    output reg [3:0] or_out // Bitwise OR output of last two D flip-flops
);reg [11:0] q_temp;          // Temporary storage for shift register output
reg [3:0] or_temp;          // Temporary storage for bitwise OR output

always @(negedge clk) begin
    if (reset == 0) begin
        q_temp <= 12'b0;
        or_temp <= 4'b0;
    end else begin
        // Shift left
        if (shift_dir == 0) begin
            q_temp[11:1] <= q[10:0];
            q_temp[0] <= data_in;
        // Shift right
        end else begin
            q_temp[10:0] <= q[11:1];
            q_temp[11] <= data_in;
        end
        // Calculate bitwise OR output
        or_temp <= q_temp[1] | q_temp[0];
    end
end

// Update shift register output and bitwise OR output
always @(posedge clk) begin
    if (reset == 0) begin
        q <= 12'b0;
        or_out <= 4'b0;
    end else begin
        q <= q_temp;
        or_out <= or_temp;
    end
end

endmodule