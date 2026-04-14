module top_module(
    input clk,
    input reset,
    output request,
    input grant,
    output [18:0] sram_tcm_address_out,
    output [1:0] sram_tcm_byteenable_n_out,
    output [0:0] sram_tcm_outputenable_n_out,
    output [0:0] sram_tcm_write_n_out,
    output [15:0] sram_tcm_data_out,
    input [15:0] sram_tcm_data_in,
    output sram_tcm_data_outen,
    output [0:0] sram_tcm_chipselect_n_out,
    input tcs0_request,
    output tcs0_grant,
    input [18:0] tcs0_tcm_address_out,
    input [1:0] tcs0_tcm_byteenable_n_out,
    input [0:0] tcs0_tcm_outputenable_n_out,
    input [0:0] tcs0_tcm_write_n_out,
    input [15:0] tcs0_tcm_data_out,
    output [15:0] tcs0_tcm_data_in,
    input tcs0_tcm_data_outen,
    input [0:0] tcs0_tcm_chipselect_n_out
);// Arbitration logic
    reg [0:0] next_grant;
    wire ack;
    assign ack = (grant == next_grant);

    always @(posedge clk) begin
        if (reset) begin
            next_grant <= 1'b0;
        end else begin
            if (ack) begin
                next_grant <= ~next_grant;
            end
        end
    end

    // SRAM signals
    assign sram_tcm_address_out = (next_grant == 1'b0) ? tcs0_tcm_address_out : 19'hx;
    assign sram_tcm_byteenable_n_out = (next_grant == 1'b0) ? tcs0_tcm_byteenable_n_out : 2'hx;
    assign sram_tcm_outputenable_n_out = (next_grant == 1'b0) ? tcs0_tcm_outputenable_n_out : 1'hx;
    assign sram_tcm_write_n_out = (next_grant == 1'b0) ? tcs0_tcm_write_n_out : 1'hx;
    assign sram_tcm_data_out = (next_grant == 1'b0) ? tcs0_tcm_data_out : 16'hx;
    assign sram_tcm_data_outen = (next_grant == 1'b0) ? tcs0_tcm_data_outen : 1'hx;
    assign sram_tcm_chipselect_n_out = (next_grant == 1'b0) ? tcs0_tcm_chipselect_n_out : 1'hx;

    // TCS signals
    assign tcs0_grant = (next_grant == 1'b1) ? ack : 1'b0;
    assign tcs0_tcm_data_in = (next_grant == 1'b1) ? sram_tcm_data_in : 16'hx;

    // Request signal
    assign request = (~grant) & ((next_grant == 1'b0) ? tcs0_request : 1'b0);

endmodule