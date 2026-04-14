module top_module(wr_rst_busy,
    empty,
    full,
    dout,
    wr_en,
    wr_clk,
    rd_clk,
    din,
    rst,
    rd_en);parameter DEPTH = 256;
    
    output wr_rst_busy;
    output empty;
    output full;
    output [7:0] dout;
    input wr_en;
    input wr_clk;
    input rd_clk;
    input [7:0] din;
    input rst;
    input rd_en;

    wire [7:0] dout;
    wire empty;
    wire full;
    reg [7:0] mem [DEPTH-1:0];
    reg [7:0] wr_ptr;
    reg [7:0] rd_ptr;
    reg [7:0] count;
    reg [7:0] next_wr_ptr;
    reg [7:0] next_rd_ptr;
    reg [7:0] next_count;
    reg wr_rst_busy;
    reg [7:0] wr_data;
    reg [7:0] rd_data;

    always @(posedge wr_clk) begin
        if (rst) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count <= 0;
            wr_rst_busy <= 1;
        end else begin
            if (wr_en && !full) begin
                mem[wr_ptr] <= din;
                next_wr_ptr <= wr_ptr + 1;
                next_count <= count + 1;
            end else begin
                next_wr_ptr <= wr_ptr;
                next_count <= count;
            end
            wr_ptr <= next_wr_ptr;
            count <= next_count;
            wr_rst_busy <= 0;
        end
    end

    always @(posedge rd_clk) begin
        if (rst) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count <= 0;
        end else begin
            if (rd_en && !empty) begin
                rd_data <= mem[rd_ptr];
                next_rd_ptr <= rd_ptr + 1;
                next_count <= count - 1;
            end else begin
                next_rd_ptr <= rd_ptr;
                next_count <= count;
            end
            rd_ptr <= next_rd_ptr;
            count <= next_count;
        end
    end

    assign empty = (count == 0);
    assign full = (count == DEPTH);
    assign dout = rd_data;
    
endmodule