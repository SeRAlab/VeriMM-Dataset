module top_module(
    input USER_CLK,
    input CHANNEL_UP,
    output reg DO_CC
);// Control state machine state registers
    reg rst_r;
    reg start_r;
    reg run_r;

    // Nextstate logic
    reg next_start_c;
    reg next_run_c;

    always @(posedge USER_CLK) begin
        if (!CHANNEL_UP) begin
            rst_r <= 1'b1;
            start_r <= 1'b0;
            run_r <= 1'b0;
        end
        else if (!DO_CC) begin
            rst_r <= 1'b0;
            start_r <= next_start_c;
            run_r <= next_run_c;
        end
    end

    // After reset, send the SCP character to open the infinite frame
    assign next_start_c = rst_r;

    // After the start state, go to normal operation
    assign next_run_c = start_r || run_r;

    // Trigger the start of the data stream
    always @(posedge USER_CLK) begin
        if (run_r) begin
            DO_CC <= 1'b1;
        end
    end

endmodule