module top_module(
    input clk,
    output reg [3:0] out
);reg [3:0] count;

always @(posedge clk) begin
    if (count == 4) begin
        count <= 9;
    end else if (count == 15) begin
        count <= 0;
    end else begin
        count <= count + 1;
    end
end

assign out = count;

endmodule