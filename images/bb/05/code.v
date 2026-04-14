module top_module(
    input clk,
    input rst_n,
    input req_compl_i,
    input compl_done_i,
    input cfg_to_turnoff_n,
    output reg cfg_turnoff_ok_n // Changed to output reg here
);reg trn_pending;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            trn_pending <= 0;
        end else begin
            if (!trn_pending && req_compl_i) begin
                trn_pending <= 1'b1;
            end else if (compl_done_i) begin
                trn_pending <= 1'b0;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cfg_turnoff_ok_n <= 1'b1;
        end else begin
            if (!cfg_to_turnoff_n && !trn_pending) begin
                cfg_turnoff_ok_n <= 1'b0;
            end else begin
                cfg_turnoff_ok_n <= 1'b1;
            end
        end
    end

endmodule