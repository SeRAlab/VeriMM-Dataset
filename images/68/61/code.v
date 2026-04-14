module top_module(
    input clk,
    input reset,   // Synchronous active-high reset
    input d,       // Data input signal for the D flip-flop
    output reg [3:1] ena, // Enable signals for the BCD counter
    output reg [15:0] q // BCD output for the final sum
);reg [3:0] bcd_counter; // 4-digit BCD counter
reg [3:0] bcd_sum; // BCD sum of counter and delayed flip-flop output
reg d_ff; // Delayed output of D flip-flop

// BCD counter
always @(posedge clk) begin
    if (reset) begin
        bcd_counter <= 4'b0000;
    end else begin
        if (ena[0]) begin
            bcd_counter[0] <= bcd_counter[0] + 1;
        end
        if (bcd_counter[0] == 5) begin
            bcd_counter[0] <= 0;
            if (ena[1]) begin
                bcd_counter[1] <= bcd_counter[1] + 1;
            end
        end
        if (bcd_counter[1] == 10) begin
            bcd_counter[1] <= 0;
            if (ena[2]) begin
                bcd_counter[2] <= bcd_counter[2] + 1;
            end
        end
        if (bcd_counter[2] == 10) begin
            bcd_counter[2] <= 0;
            bcd_counter[3] <= bcd_counter[3] + 1;
        end
        if (bcd_counter[3] == 10) begin
            bcd_counter[3] <= 0;
        end
    end
end

// D flip-flop
assign d_ff = ~(d & clk);

// BCD sum
always @(posedge clk) begin
    if (reset) begin
        bcd_sum <= 4'b0000;
    end else begin
        bcd_sum <= bcd_counter + {1'b0, d_ff};
    end
end

// Output
assign q = {bcd_sum[15:12], bcd_sum[11:8], bcd_sum[7:4], bcd_sum[3:0]};

endmodule