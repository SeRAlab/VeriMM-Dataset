module top_module(
    input clk,
    input rst_n,
    input rd,
    input fifo_empty,
    output reg [4:0] rptr,
    output reg fifo_rd
);reg [4:0] read_pointer = 0;
    wire read_enable = (!fifo_empty) && rd;

    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            read_pointer <= 0;
        end
        else if (read_enable) begin
            read_pointer <= read_pointer + 1;
        end
    end

    assign rptr = read_pointer;
    assign fifo_rd = read_enable;

    always @(posedge clk) begin
        $write("%h %h %h %h %h %h\n", rd, fifo_empty, rptr, fifo_rd, clk, rst_n);
    end

endmodule