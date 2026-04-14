module top_module(
    input se,
    input clk,
    input si_l,
    input synced_upd_imped,
    input hard_reset_n,
    input reset_l,
    output reg updclk,
    output reg so_l,
    output reg avgcntr_rst,
    output reg bypass,
    output reg global_reset_n,
    output reg sclk,
    output reg int_sclk
);reg [3:0] count;
reg [3:0] sync_count;

always @(posedge clk) begin
    if (hard_reset_n == 1'b0) begin
        count <= 4'b0;
        sync_count <= 4'b0;
        updclk <= 1'b0;
        so_l <= 1'b0;
        avgcntr_rst <= 1'b0;
        bypass <= 1'b0;
        global_reset_n <= 1'b0;
        sclk <= 1'b0;
        int_sclk <= 1'b0;
    end else if (reset_l == 1'b0) begin
        count <= 4'b0;
        sync_count <= 4'b0;
        updclk <= 1'b0;
        so_l <= 1'b0;
        avgcntr_rst <= 1'b0;
        bypass <= 1'b0;
        global_reset_n <= 1'b0;
        sclk <= 1'b0;
        int_sclk <= 1'b0;
    end else begin
        count <= count + 1;
        if (count == 4'b1000) begin
            count <= 4'b0;
            updclk <= ~updclk;
        end
        if (sync_count == 4'b1000) begin
            sync_count <= 4'b0;
            sclk <= ~sclk;
        end else begin
            sync_count <= sync_count + 1;
        end
        if (si_l == 1'b1 && bypass == 1'b0 && global_reset_n == 1'b1) begin
            int_sclk <= ~int_sclk;
        end else begin
            int_sclk <= 1'b0;
        end
    end
end

always @(posedge sclk) begin
    so_l <= int_sclk;
    if (synced_upd_imped == 1'b1) begin
        avgcntr_rst <= 1'b1;
    end else begin
        avgcntr_rst <= 1'b0;
    end
end

endmodule