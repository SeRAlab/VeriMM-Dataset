module top_module(
    input RX_SP,
    input ready_r,
    input USER_CLK,
    input RX_NEG,
    input ack_r,
    input count_128d_done_r,
    input polarity_r,
    output reg remote_reset_watchdog_done_r,
    output reg watchdog_done_r,
    output reg sp_polarity_c,
    output reg RX_POLARITY
);reg [15:0] counter4_r;
reg [15:0] counter5_r;
reg prev_count_128d_done_r;
reg do_watchdog_count_r;
reg rx_polarity_r;

// reset all the lanes if RX_SP is asserted while they are all in the lane ready state
always @(posedge USER_CLK) begin
    if (RX_SP && ready_r) begin
        remote_reset_watchdog_done_r <= 0;
        watchdog_done_r <= 0;
        counter4_r <= 16'b0; // Reset counter4_r
        counter5_r <= 16'b0; // Reset counter5_r
    end
end

// counter4 logic
always @(posedge USER_CLK) begin
    if (RX_SP || !ready_r) begin
        counter4_r <= {counter4_r[14:0], ready_r}; // Corrected part-select order
    end
end

// the counter is done when a 1 reaches the end of the shift register
always @(posedge USER_CLK) begin
    remote_reset_watchdog_done_r <= counter4_r[15]; // Changed to a procedural assignment
end

// counter5 logic
always @(posedge USER_CLK) begin
    if (do_watchdog_count_r || !ack_r) begin
        counter5_r <= {counter5_r[14:0], ack_r}; // Corrected part-select order
    end
end

// store the count_128d_done_r result from the previous cycle
always @(posedge USER_CLK) begin
    prev_count_128d_done_r <= count_128d_done_r;
end

// trigger CE only when the previous 128d_done is not the same as the current one, and the current value is high
always @(posedge USER_CLK) begin
    do_watchdog_count_r <= count_128d_done_r && !prev_count_128d_done_r; // Use logical AND
end

// the counter is done when bit 15 is high
always @(posedge USER_CLK) begin
    watchdog_done_r <= counter5_r[15]; // Changed to a procedural assignment
end

// polarity control
always @(*) begin
    sp_polarity_c = !RX_NEG; // Make this continuous assignment
end

// initialize the rx_polarity register for simulation purposes
initial begin
    rx_polarity_r = 1'b0;
end

// update the rx_polarity register based on the received symbols
always @(posedge USER_CLK) begin
    if (polarity_r && !sp_polarity_c) begin
        rx_polarity_r <= ~rx_polarity_r;
    end
end

// drive the rx_polarity register value on the interface
always @(*) begin
    RX_POLARITY = rx_polarity_r; // Make this continuous assignment
end

endmodule