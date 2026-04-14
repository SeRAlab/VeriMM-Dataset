module top_module(
    clk,
    rst_n,
    strand_offset,
    strand_idx,
    strand_length,
    addr
);parameter MEM_ADDR_WIDTH = 24;
    parameter STRAND_PARAM_WIDTH = 16;

    input clk;
    input rst_n;

    // The active strand will drive these three buses
    input [STRAND_PARAM_WIDTH-1:0] strand_offset;
    input [STRAND_PARAM_WIDTH-1:0] strand_idx;
    input [STRAND_PARAM_WIDTH-1:0] strand_length;

    output reg [MEM_ADDR_WIDTH-1:0] addr;

    // Address generation process
    always @(posedge clk) begin
        if (rst_n == 1'b0) begin
            addr <= { MEM_ADDR_WIDTH {1'b0} };
        end
        else begin
            // address of memory is given by 
            // strand_offset[current] + (strand_idx[current] % strand_length[current])
            if (strand_idx >= strand_length) begin
                addr <= strand_offset + (strand_idx - strand_length);
            end
            else begin
                addr <= strand_offset + strand_idx;
            end
        end
    end

endmodule