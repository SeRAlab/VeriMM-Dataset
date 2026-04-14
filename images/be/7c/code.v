module top_module(
    input clk,
    input rst,
    input [31:0] data_in,
    output reg [31:0] average
);reg [31:0] sum;
    reg [7:0] count; // count up to 100

    always @(posedge clk) begin
        if (rst) begin
            sum <= 0;
            count <= 0;
            average <= 0;
        end
        else begin
            sum <= sum + data_in[count];
            count <= count + 1;
            if (count == 99) begin // 99 instead of 100 to account for 0-indexing
                average <= sum / 100;
            end
        end
    end

endmodule