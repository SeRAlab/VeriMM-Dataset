module top_module(
    input wire clk,
    input wire rst,
    input wire wr_en,
    input wire rd_en,
    input wire [8:0] din,
    output wire [8:0] dout,
    output wire full,
    output wire empty
);reg [8:0] mem [63:0];
    reg [5:0] wr_ptr = 0;
    reg [5:0] rd_ptr = 0;
    reg [5:0] count = 0;
    wire [5:0] next_wr_ptr;
    wire [5:0] next_rd_ptr;
    wire [5:0] next_count;

    assign full = (count == 64);
    assign empty = (count == 0);
    assign dout = mem[rd_ptr];

    always @(posedge clk) begin
        if (rst) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count <= 0;
        end else begin
            if (wr_en && !full) begin
                mem[wr_ptr] <= din;
                wr_ptr <= next_wr_ptr;
                count <= next_count;
            end

            if (rd_en && !empty) begin
                rd_ptr <= next_rd_ptr;
                count <= next_count;
            end
        end
    end

    assign next_wr_ptr = (wr_ptr == 63) ? 0 : wr_ptr + 1;
    assign next_rd_ptr = (rd_ptr == 63) ? 0 : rd_ptr + 1;
    assign next_count = (wr_en && !full) ? count + 1 :
                        (rd_en && !empty) ? count - 1 :
                        count;

endmodule