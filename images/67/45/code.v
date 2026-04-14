module sync_fifo(
    input               clk     , 
    input               rst     ,
    input               wr_en   ,
    input               rd_en   ,
    input       [15:0]  data_in ,

    output reg  [15:0]  data_out,
    output              empty   ,
    output              full
);

reg [15:0] mem [31:0];
reg [4:0]  rd_ptr, wr_ptr;
reg [4:0]  fifo_count;

assign empty = (fifo_count == 0);
assign full  = (fifo_count == 32);

// Write operation
always @(posedge clk) begin
    if (rst) begin
        wr_ptr <= 0;
    end else if (wr_en && !full) begin
        mem[wr_ptr] <= data_in;
        wr_ptr <= wr_ptr + 1;
    end
end

// Read operation
always @(posedge clk) begin
    if (rst) begin
        rd_ptr <= 0;
    end else if (rd_en && !empty) begin
        data_out <= mem[rd_ptr];
        rd_ptr <= rd_ptr + 1;
    end
end

// FIFO count management
always @(posedge clk) begin
    if (rst) begin
        fifo_count <= 0;
    end else if (wr_en && !full && !(rd_en && !empty)) begin
        fifo_count <= fifo_count + 1;
    end else if (rd_en && !empty && !(wr_en && !full)) begin
        fifo_count <= fifo_count - 1;
    end
end

endmodule