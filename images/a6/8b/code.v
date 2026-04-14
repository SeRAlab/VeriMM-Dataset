module top_module(
    input clk,
    input [7:0] data_in1,
    input [7:0] data_in2,
    input select,
    input reset,
    output reg [7:0] sum_out
);reg [3:0] count;
reg [7:0] output1;
reg [7:0] output2;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0;
        output1 <= 8'b0;
        output2 <= 8'b0;
    end else begin
        count <= count + 1;
        output1 <= data_in1;
        output2 <= data_in2;
    end
end

always @(*) begin
    if (select) begin
        sum_out = output2 + (count * 2);
    end else begin
        sum_out = output1 + (count * 2);
    end
end

endmodule