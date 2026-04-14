module top_module(
    input reset, clk,
    input rd, wr,
    input [7:0] data_in,
    output reg [7:0] data_out
    );parameter DEPTH = 16;

    reg [7:0] memory [0:DEPTH-1];
    reg [3:0] wr_ptr = 0;
    reg [3:0] rd_ptr = 0;
    reg [3:0] count = 0;

    always @(posedge clk) begin
        if (reset) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count <= 0;
        end else begin
            if (wr && rd) begin
                // do nothing
            end else if (wr) begin
                memory[wr_ptr] <= data_in;
                wr_ptr <= wr_ptr + 1;
                count <= count + 1;
            end else if (rd) begin
                data_out <= memory[rd_ptr];
                rd_ptr <= rd_ptr + 1;
                count <= count - 1;
            end
        end
    end

endmodule