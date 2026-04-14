module top_module(clk, load, data, count);input clk, load;
input [7:0] data;
output reg [7:0] count;

always @(posedge clk) begin
    if (load) begin
        count <= data;
    end else begin
        count <= count + 1;
    end
end

endmodule