module top_module(
    input clk,
    input load,
    input [3:0] load_value,
    output reg [3:0] count
);reg [3:0] count_reg1, count_reg2;

always @(posedge clk) begin
    if (load) begin
        count_reg1 <= load_value;
    end else begin
        count_reg1 <= count_reg2 + 4'b1;
    end
end

always @(posedge clk) begin
    count_reg2 <= count_reg1;
end

assign count = count_reg2;

endmodule