module top_module(
    input clk,
    input rst,
    input up_down,
    input load,
    input [3:0] data_in,
    output reg [3:0] q
);reg [3:0] count;

    always @(posedge clk, negedge rst) begin
        if (rst == 0) begin
            count <= 4'b0000;
        end else if (load == 1) begin
            count <= data_in;
        end else if (up_down == 1) begin
            count <= count + 1;
        end else begin
            count <= count - 1;
        end
    end

    assign q = count;

endmodule