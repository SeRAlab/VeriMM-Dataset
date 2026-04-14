module top_module(
    input clk,
    input rst,
    input wr_en,
    input rd_en,
    input [31:0] wr_data,
    output reg [31:0] rd_data,  // Changed to reg as it is driven in an always block
    output full,
    output empty
);parameter WIDTH = 32;
    parameter DEPTH = 512;
    parameter ADDR_WIDTH = $clog2(DEPTH);
    parameter FULL_THRESHOLD = DEPTH - 1;  // Adjusted threshold for wraparound
    parameter EMPTY_THRESHOLD = 0;

    reg [ADDR_WIDTH-1:0] wr_ptr;
    reg [ADDR_WIDTH-1:0] rd_ptr;
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    reg full_reg;  // Changed to reg
    reg empty_reg; // Changed to reg

    assign full = full_reg;  // Assign the reg to the output
    assign empty = empty_reg; // Assign the reg to the output

    always @(posedge clk) begin
        if (rst) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            full_reg <= 0;       // Reset full_reg
            empty_reg <= 1;      // Reset empty_reg
        end else begin
            if (wr_en && !full_reg) begin
                mem[wr_ptr] <= wr_data;
                wr_ptr <= wr_ptr + 1;
                if (wr_ptr == FULL_THRESHOLD) begin
                    wr_ptr <= 0;
                end
            end
            if (rd_en && !empty_reg) begin
                rd_data <= mem[rd_ptr];
                rd_ptr <= rd_ptr + 1;
                if (rd_ptr == FULL_THRESHOLD) begin
                    rd_ptr <= 0;
                end
            end
            full_reg <= (wr_ptr == rd_ptr) && (wr_en != rd_en);
            empty_reg <= (wr_ptr == rd_ptr) && (wr_en == rd_en);
        end
    end

endmodule