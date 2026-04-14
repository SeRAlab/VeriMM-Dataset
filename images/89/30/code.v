module top_module(
    input clk,
    input rst,
    input load,
    input up_down,
    input [2:0] data_in,
    output reg [2:0] count
);reg [2:0] count_reg;
reg [2:0] count_next;

always @(posedge clk) begin
    if (rst) begin
        count_reg <= 3'b0;
    end
    else begin
        count_reg <= count_next;
    end
end

always @(*) begin
    if (load) begin
        count_next = data_in;
    end
    else if (up_down) begin
        count_next = count_reg + 3'b1;
    end
    else begin
        count_next = count_reg - 3'b1;
    end
end

assign count = count_reg;

endmodule