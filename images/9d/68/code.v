module top_module(
    input clk,
    input rst,
    input load,
    input [3:0] data_in,
    output [3:0] count_out
);reg [3:0] count;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 4'b0000;
    end else if (load) begin
        count <= data_in;
    end else begin
        count <= count + 1;
    end
end

assign count_out = count;

endmodule