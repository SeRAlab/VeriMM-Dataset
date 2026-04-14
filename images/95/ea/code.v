module top_module(
    input ctl_clk,
    input ctl_reset_n,
    input burst_valid,
    input burst_ready,
    input burst_consumed_valid,
    input [31:0] burst_consumed_burstcount,
    output reg [31:0] burst_counter,
    output reg [31:0] burst_pending_burstcount,
    output reg [31:0] burst_next_pending_burstcount,
    output reg burst_accepted
);always @ (*) begin
        burst_pending_burstcount = burst_counter;
        if (burst_ready & burst_valid) begin
            burst_accepted = 1;
            if (burst_consumed_valid) begin
                burst_next_pending_burstcount = burst_counter - burst_consumed_burstcount;
                burst_counter = burst_counter - burst_consumed_burstcount;
            end else begin
                burst_next_pending_burstcount = burst_counter + 1;
                burst_counter = burst_counter + 1;
            end
        end else begin
            burst_accepted = 0;
            burst_next_pending_burstcount = burst_counter;
        end
    end

    always @ (posedge ctl_clk or negedge ctl_reset_n) begin
        if (~ctl_reset_n) begin
            burst_counter <= 0;
        end else begin
            burst_counter <= burst_counter;
        end
    end
    
endmodule