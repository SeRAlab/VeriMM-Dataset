module top_module(
    input clk,
    input rst,
    output reg [2:0] out
);reg [2:0] count;

always @(posedge clk) begin
    if (rst) begin
        count <= 3'b0;
    end else if (count == 3'b111) begin
        count <= 3'b0;
    end else begin
        count <= count + 1;
    end
end

assign out = count;

endmodule