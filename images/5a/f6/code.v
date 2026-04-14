module top_module(
    input clk,
    input rst_n,
    input core_cgstop,
    input itcm_active,
    input dtcm_active,
    output reg clk_itcm,
    output reg clk_dtcm,
    output reg itcm_ls,
    output reg dtcm_ls
);reg itcm_active_r;
    reg dtcm_active_r;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            itcm_active_r <= 1'b0;
            dtcm_active_r <= 1'b0;
            clk_itcm <= 1'b0;
            clk_dtcm <= 1'b0;
            itcm_ls <= 1'b1;
            dtcm_ls <= 1'b1;
        end else begin
            itcm_active_r <= itcm_active;
            dtcm_active_r <= dtcm_active;

            if (core_cgstop) begin
                clk_itcm <= 1'b0;
                clk_dtcm <= 1'b0;
                itcm_ls <= 1'b1;
                dtcm_ls <= 1'b1;
            end else begin
                if (itcm_active | itcm_active_r) begin
                    clk_itcm <= 1'b1;
                    itcm_ls <= 1'b0;
                end else begin
                    clk_itcm <= 1'b0;
                    itcm_ls <= 1'b1;
                end

                if (dtcm_active | dtcm_active_r) begin
                    clk_dtcm <= 1'b1;
                    dtcm_ls <= 1'b0;
                end else begin
                    clk_dtcm <= 1'b0;
                    dtcm_ls <= 1'b1;
                end
            end
        end
    end

endmodule