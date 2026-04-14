module top_module(
    input clk,
    input rst,
    input [7:0] din,
    input wr_en,
    input rd_en,
    output reg empty,
    output reg full,
    output reg [7:0] dout
);// Declare internal variables
    reg [3:0] wr_ptr;
    reg [3:0] rd_ptr;
    reg [7:0] mem [0:15];
    reg [3:0] count;

    // Reset logic
    always @(posedge clk) begin
        if (rst) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            empty <= 1;
            full <= 0;
            count <= 0;
        end
    end

    // Write logic
    always @(posedge clk) begin
        if (wr_en && !full) begin
            mem[wr_ptr] <= din;
            wr_ptr <= wr_ptr + 1;
            count <= count + 1;
            empty <= 0;
            if (wr_ptr == 15) full <= 1;
        end
    end

    // Read logic
    always @(posedge clk) begin
        if (rd_en && !empty) begin
            dout <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
            count <= count - 1;
            full <= 0;
            if (rd_ptr == 15) empty <= 1;
        end
    end

endmodule