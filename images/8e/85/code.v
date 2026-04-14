module top_module(
    input wire clk,
    input wire clear,
    input wire read_en,
    input wire write_en,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg empty,
    output reg full
);parameter DEPTH = 256;
    parameter ADDR_WIDTH = $clog2(DEPTH);
    parameter DATA_WIDTH = 8;
    
    reg [DATA_WIDTH-1:0] mem [DEPTH-1:0];
    reg [ADDR_WIDTH-1:0] read_ptr;
    reg [ADDR_WIDTH-1:0] write_ptr;
    reg [ADDR_WIDTH-1:0] next_read_ptr;
    reg [ADDR_WIDTH-1:0] next_write_ptr;
    
    assign empty = (read_ptr == write_ptr) & !write_en;
    assign full = (read_ptr == next_write_ptr) & write_en;
    
    always @(posedge clk) begin
        if (clear) begin
            read_ptr <= 0;
            write_ptr <= 0;
        end else begin
            if (read_en & !empty) begin
                data_out <= mem[read_ptr];
                read_ptr <= next_read_ptr;
            end
            if (write_en & !full) begin
                mem[write_ptr] <= data_in;
                write_ptr <= next_write_ptr;
            end
        end
    end
    
    always @(*) begin
        next_read_ptr = read_ptr + read_en;
        next_write_ptr = write_ptr + write_en;
        if (next_read_ptr == next_write_ptr) begin
            next_read_ptr = read_ptr;
            next_write_ptr = write_ptr;
        end
    end

endmodule