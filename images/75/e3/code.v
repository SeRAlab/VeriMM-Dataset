module top_module(
    input clk,
    input rst,
    input load,
    input [7:0] load_value,
    output reg [7:0] count
);always @(posedge clk, posedge rst) begin
    if (rst) begin
        count <= 0;
    end else if (load) begin
        count <= load_value;
    end else if (count == 255) begin
        count <= 0;
    end else begin
        count <= count + 1;
    end
end

endmodule