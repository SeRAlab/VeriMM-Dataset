module top_module(
    input wr_clk,
    input wr_en,
    input [31:0] wr_data,
    input rd_clk,
    input rd_en,
    output reg [31:0] rd_data, // Make rd_data a reg since it will be assigned in an always block
    output wire empty,
    output wire full
);// Declare parameters and local variables
    parameter BUFFER_SIZE = 16384; // 16 kilobytes
    parameter WORD_SIZE = 32; // 32 bits
    parameter ADDR_WIDTH = $clog2(BUFFER_SIZE/WORD_SIZE); // Address width for buffer memory
    reg [ADDR_WIDTH-1:0] wr_ptr, rd_ptr;
    reg [WORD_SIZE-1:0] buffer [0:BUFFER_SIZE/WORD_SIZE-1];
    
    // FIFO status signals
    assign empty = (wr_ptr == rd_ptr);
    assign full = ((wr_ptr + 1) % (BUFFER_SIZE/WORD_SIZE) == rd_ptr);

    // Write logic
    always @(posedge wr_clk) begin
        if (wr_en && !full) begin
            buffer[wr_ptr] <= wr_data;
            wr_ptr <= (wr_ptr + 1) % (BUFFER_SIZE/WORD_SIZE);
        end
    end

    // Read logic
    always @(posedge rd_clk) begin
        if (rd_en && !empty) begin
            rd_data <= buffer[rd_ptr];
            rd_ptr <= (rd_ptr + 1) % (BUFFER_SIZE/WORD_SIZE);
        end
    end

endmodule