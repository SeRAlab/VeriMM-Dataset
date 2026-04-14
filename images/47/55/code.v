module top_module(
    input wire ENA_I,
    input wire ENB_I,
    input wire POR_A,
    input wire [7:0] RD_PNTR,
    input wire [7:0] WR_PNTR,
    input wire s_dclk_o,
    input wire aclk,
    input wire p_20_out,
    input wire [31:0] rx_fifo_data_o_reg,
    output reg [31:0] D,
    output reg ENB_dly_D
);reg [31:0] mem [255:0];
    reg [31:0] data_in;
    reg [7:0] rd_ptr;
    reg [7:0] wr_ptr;
    reg [31:0] fifo_data;

    always @(posedge aclk) begin
        if (POR_A) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
        end else begin
            if (ENA_I) begin
                rd_ptr <= RD_PNTR;
            end
            if (ENB_I) begin
                wr_ptr <= WR_PNTR;
                mem[wr_ptr] <= data_in;
            end
        end
    end

    always @(posedge s_dclk_o) begin
        if (p_20_out) begin
            fifo_data <= rx_fifo_data_o_reg;
        end
    end

    always @(*) begin
        D = mem[rd_ptr];
        ENB_dly_D = ENB_I;
        data_in = fifo_data;
    end

endmodule