module top_module(
    // Lane Init SM Interface
    input ENABLE_ERROR_DETECT,
    input HARD_ERROR_RESET,

    // Global Logic Interface
    output reg SOFT_ERROR,
    output reg HARD_ERROR,

    // MGT Interface
    input RX_DISP_ERR,
    input TX_K_ERR,
    input RX_NOT_IN_TABLE,
    input RX_BUF_STATUS,
    input TX_BUF_ERR,
    input RX_REALIGN,

    // System Interface
    input USER_CLK
);reg [31:0] data;
reg [3:0] error_count;

always @(posedge USER_CLK) begin
    if (ENABLE_ERROR_DETECT) begin
        if (HARD_ERROR_RESET) begin
            SOFT_ERROR <= 0;
            HARD_ERROR <= 0;
            error_count <= 0;
        end else begin
            if (RX_DISP_ERR || TX_K_ERR || RX_NOT_IN_TABLE || RX_BUF_STATUS || TX_BUF_ERR || RX_REALIGN) begin
                SOFT_ERROR <= 1;
                error_count <= error_count + 1;
                if (error_count == 15) begin
                    HARD_ERROR <= 1;
                end
            end else begin
                SOFT_ERROR <= 0;
                error_count <= 0;
                HARD_ERROR <= 0;
            end
        end
    end else begin
        SOFT_ERROR <= 0;
        HARD_ERROR <= 0;
        error_count <= 0;
    end
end

endmodule