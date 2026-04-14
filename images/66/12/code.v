module top_module(
    input clk_i,
    input reset_i,
    input [3:0] count_i,
    output [3:0] count_o
);reg [3:0] count;

    assign count_o = count;

    always @(posedge clk_i) begin
        if (reset_i) begin
            count <= 0;
        end else if (count == 15) begin
            count <= 0;
        end else begin
            count <= count + 1;
        end
    end

endmodule