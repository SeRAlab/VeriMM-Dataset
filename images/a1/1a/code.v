module top_module(
    input wr_clk,
    input wr_en,
    input [31:0] din,
    input rst,
    output rd_clk,
    output reg rd_en,
    output reg [31:0] dout,  // Changed from wire to reg
    output empty,
    output full,
    output [4:0] wr_data_count,
    output [4:0] rd_data_count,
    output prog_empty,
    output prog_full
);reg [31:0] fifo [0:15];
    reg [3:0] wr_ptr = 0;
    reg [3:0] rd_ptr = 0;
    reg [4:0] wr_count = 0;
    reg [4:0] rd_count = 0;
    wire [3:0] next_wr_ptr;
    wire [3:0] next_rd_ptr;
    wire [4:0] next_wr_count;
    wire [4:0] next_rd_count;
    wire empty_n;
    wire full_n;

    assign next_wr_ptr = wr_ptr + 1;
    assign next_rd_ptr = rd_ptr + 1;
    assign next_wr_count = wr_count + 1;
    assign next_rd_count = rd_count - 1;

    assign empty_n = (wr_count != rd_count);
    assign full_n = (wr_count != 16);

    always @(posedge wr_clk) begin
        if (rst) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            wr_count <= 0;
            rd_count <= 0;
            rd_en <= 0;
        end else begin
            if (wr_en && full_n) begin
                fifo[wr_ptr] <= din;
                wr_ptr <= next_wr_ptr;
                wr_count <= next_wr_count;
            end
            rd_en <= (~empty_n && rd_en);
        end
    end

    always @(posedge rd_clk) begin
        if (rst) begin
            rd_en <= 0;
            dout <= 0;  // Initialize dout on reset
        end else begin
            if (rd_en && ~empty_n) begin
                dout <= fifo[rd_ptr];
                rd_ptr <= next_rd_ptr;
                rd_count <= next_rd_count;
            end
        end
    end

    assign rd_clk = wr_clk;

    assign empty = ~empty_n;
    assign full = ~full_n;

    assign wr_data_count = wr_count;
    assign rd_data_count = rd_count;

    assign prog_empty = (wr_count <= 2);
    assign prog_full = (wr_count >= 14);

endmodule