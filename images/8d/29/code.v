module top_module(
    input clk,
    input rst_n,
    input wr_en,
    input rd_en,
    input [31:0] data_in,
    output [31:0] data_out,
    output full,
    output empty
);parameter DEPTH = 1024;
    parameter WIDTH = 32;

    reg [WIDTH-1:0] buffer [0:DEPTH-1];
    reg [WIDTH-1:0] data_out_reg;
    reg [9:0] head = 0;
    reg [9:0] tail = 0;
    wire [9:0] count = head - tail;

    assign full = (count == DEPTH);
    assign empty = (count == 0);
    assign data_out = data_out_reg;

    integer i;  // Declare the integer variable i for the for loop

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            head <= 0;
            tail <= 0;
            data_out_reg <= 0;
            for (i = 0; i < DEPTH; i = i + 1) begin
                buffer[i] <= 0;
            end
        end
        else begin
            if (wr_en && ~full) begin
                buffer[head] <= data_in;
                head <= head + 1;
            end
            if (rd_en && ~empty) begin
                data_out_reg <= buffer[tail];
                tail <= tail + 1;
            end
        end
    end

endmodule