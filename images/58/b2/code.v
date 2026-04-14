module top_module(
    input rst,
    input wr_clk,
    input rd_clk,
    input [31:0] din,
    input wr_en,
    input rd_en,
    output [31:0] dout,
    output full,
    output empty,
    output reg [2:0] rd_data_count,
    output reg [1:0] wr_data_count
);reg [31:0] mem [1023:0];
    reg [9:0] wr_ptr;
    reg [9:0] rd_ptr;
    reg [1:0] wr_count;
    reg [1:0] rd_count;
    reg [1:0] rd_count_next; // Change to reg type
    reg [31:0] dout_reg;
    reg full_reg;
    reg empty_reg;

    // Reset the buffer
    always @(posedge wr_clk or negedge rst) begin
        if (~rst) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            wr_count <= 0;
            rd_count <= 0;
            rd_data_count <= 0;
            wr_data_count <= 3;
            dout_reg <= 0;
            full_reg <= 0;
            empty_reg <= 1;
        end
    end

    // Write data to the buffer
    always @(posedge wr_clk) begin
        if (wr_en && ~full_reg) begin
            mem[wr_ptr] <= din;
            wr_ptr <= wr_ptr + 1;
            wr_count <= wr_count + 1;
            wr_data_count <= wr_data_count - 1;
            empty_reg <= 0;
            if (wr_ptr == 1023) begin
                wr_ptr <= 0;
            end
            if (wr_count == 511) begin
                full_reg <= 1;
            end
        end
    end

    // Read data from the buffer
    always @(posedge rd_clk) begin
        if (rd_en && ~empty_reg) begin
            dout_reg <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1; // Move to the next read pointer
            rd_data_count <= rd_count; // Keep track of rd_data_count
            rd_count <= rd_count_next; // Update rd_count
            if (rd_ptr == 1023) begin
                rd_ptr <= 0;
            end
            if (rd_count_next == 0) begin
                empty_reg <= 1;
            end
        end
    end

    // Update read count
    always @(*) begin
        rd_count_next = rd_count - rd_en + wr_en; // Modified to update rd_count_next
    end

    assign dout = dout_reg;
    assign full = full_reg;
    assign empty = empty_reg;

endmodule