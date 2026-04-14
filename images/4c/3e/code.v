module top_module(
  clk,
  rst,
  din,
  wr_en,
  rd_en,
  dout,
  full,
  empty
);input clk;
input rst;
input [7:0] din;
input wr_en;
input rd_en;
output reg [7:0] dout; // Changed to reg
output reg full;       // Changed to reg
output reg empty;      // Changed to reg

reg [7:0] buffer [0:15];
reg [3:0] write_ptr;
reg [3:0] read_ptr;

always @(posedge clk) begin
    if (rst) begin
        write_ptr <= 0;
        read_ptr <= 0;
        full <= 0;
        empty <= 1;
    end else begin
        if (wr_en && !full) begin
            buffer[write_ptr] <= din;
            write_ptr <= write_ptr + 1;
            if (write_ptr == 15) begin // changed to 15 to optimize
                write_ptr <= 0;
            end
            if (write_ptr + 1 == read_ptr) begin // Update full condition
                full <= 1;
            end
            empty <= 0;
        end
        if (rd_en && !empty) begin
            dout <= buffer[read_ptr];
            read_ptr <= read_ptr + 1;
            if (read_ptr == 15) begin // changed to 15 to optimize
                read_ptr <= 0;
            end
            if (read_ptr + 1 == write_ptr) begin // Update empty condition
                empty <= 1;
            end
            full <= 0;
        end
    end
end

endmodule