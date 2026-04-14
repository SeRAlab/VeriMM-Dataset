module top_module(
    input wire clk,
    input wire reset,
    input wire pll_locked,
    output reg TXENPMAPHASEALIGN,
    output reg TXPMASETPHASE,
    output reg SYNC_DONE
);reg [3:0] begin_r, wait_stable_r, phase_align_r, ready_r;
    reg [9:0] wait_before_sync_r;
    reg [14:0] sync_counter_r;
    wire count_512_complete_r, sync_count_complete_r;
    parameter SYNC_CYCLES = 15'd50;

    // State registers
    always @(posedge clk) begin
        if (reset) begin_r <= 4'b1000;
        else begin
            begin_r <= 1'b0;
            wait_stable_r <= next_wait_stable_c;
            phase_align_r <= next_phase_align_c;
            ready_r <= next_ready_c;
        end
    end

    // Next state logic
    assign next_wait_stable_c = begin_r | (wait_stable_r & ~count_512_complete_r);
    assign next_phase_align_c = (wait_stable_r & count_512_complete_r) | (phase_align_r & ~sync_count_complete_r);
    assign next_ready_c = (phase_align_r & sync_count_complete_r) | ready_r;

    // Counter for waiting for PLL to be stable before sync
    always @(posedge clk) begin
        if (!wait_stable_r) wait_before_sync_r <= 10'b0;
        else wait_before_sync_r <= wait_before_sync_r + 1'b1;
    end

    assign count_512_complete_r = wait_before_sync_r[9];

    // Counter for holding SYNC for SYNC_CYCLES
    always @(posedge clk) begin
        if (!phase_align_r) sync_counter_r <= 15'b0;
        else sync_counter_r <= sync_counter_r + 1'b1;
    end

    assign sync_count_complete_r = sync_counter_r[14:12] == SYNC_CYCLES;

    // Assign the phase align ports into the GTP
    assign TXENPMAPHASEALIGN = ~begin_r;
    assign TXPMASETPHASE = phase_align_r;

    // Assign the sync_done port
    assign SYNC_DONE = ready_r;

endmodule