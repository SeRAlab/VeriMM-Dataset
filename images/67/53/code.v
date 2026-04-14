module top_module(
    input [4:0] ra_i,
    input [4:0] rb_i,
    input [31:0] ra_regval_i,
    input [31:0] rb_regval_i,
    input [4:0] rd_ex_i,
    input [4:0] rd_wb_i,
    input load_pending_i,
    input [4:0] rd_load_i,
    input mult_ex_i,
    input [31:0] result_ex_i,
    input [31:0] result_wb_i,
    output reg [31:0] result_ra_o,
    output reg [31:0] result_rb_o,
    output reg resolved_o,
    output reg stall_o
);always @ (*) begin
    result_ra_o = ra_regval_i;
    result_rb_o = rb_regval_i;
    stall_o = 1'b0;
    resolved_o = 1'b0;

    // RA forwarding
    if (ra_i != 5'b00000) begin
        // RA from load
        if (ra_i == rd_load_i && load_pending_i) begin
            stall_o = 1'b1;
        end
        // RA from PC-4 (exec)
        else if (ra_i == rd_ex_i) begin
            if (mult_ex_i) begin
                stall_o = 1'b1;
            end
            else begin
                result_ra_o = result_ex_i;
                resolved_o = 1'b1;
            end
        end
        // RA from PC-8 (writeback)
        else if (ra_i == rd_wb_i) begin
            result_ra_o = result_wb_i;
            resolved_o = 1'b1;
        end
    end

    // RB forwarding
    if (rb_i != 5'b00000) begin
        // RB from load
        if (rb_i == rd_load_i && load_pending_i) begin
            stall_o = 1'b1;
        end
        // RB from PC-4 (exec)
        else if (rb_i == rd_ex_i) begin
            if (mult_ex_i) begin
                stall_o = 1'b1;
            end
            else begin
                result_rb_o = result_ex_i;
                resolved_o = 1'b1;
            end
        end
        // RB from PC-8 (writeback)
        else if (rb_i == rd_wb_i) begin
            result_rb_o = result_wb_i;
            resolved_o = 1'b1;
        end
    end
end

endmodule