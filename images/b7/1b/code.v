module top_module(
    input clk,
    input reset,
    input load,
    input [3:0] data_in,
    output reg [3:0] count
);reg [3:0] count_reg;
reg [3:0] count_next;

always @(posedge clk) begin
    if (reset) begin
        count_reg <= 4'b0;
    end
    else begin
        count_reg <= count_next;
    end
end

always @(*) begin
    if (load) begin
        count_next = data_in;
    end
    else begin
        count_next = count_reg + 4'b1;
    end
end

assign count = count_reg;

endmodule