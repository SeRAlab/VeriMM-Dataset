module top_module(
    input [NUM_OF_BITS-1:0] in,
    input out_resetn,
    input out_clk,
    output [NUM_OF_BITS-1:0] out
);// Number of bits to synchronize
    parameter NUM_OF_BITS = 1;
    // Whether input and output clocks are asynchronous, if 0 the synchronizer will
    // be bypassed and the output signal equals the input signal.
    parameter ASYNC_CLK = 1;

    reg [NUM_OF_BITS-1:0] cdc_sync_stage1 = 'h0;
    reg [NUM_OF_BITS-1:0] cdc_sync_stage2 = 'h0;

    always @(posedge out_clk)
    begin
        if (out_resetn == 1'b0) begin
            cdc_sync_stage1 <= 'b0;
            cdc_sync_stage2 <= 'b0;
        end else begin
            cdc_sync_stage1 <= in;
            cdc_sync_stage2 <= cdc_sync_stage1;
        end
    end

    assign out = ASYNC_CLK ? cdc_sync_stage2 : in;

endmodule