module top_module(
    input clk_in,
    input reset,
    output reg clk_out_1,
    output reg clk_out_2
);reg [1:0] count;

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            clk_out_1 <= 1'b0;
            clk_out_2 <= 1'b0;
            count <= 2'b00;
        end else begin
            count <= count + 1;
            if (count == 2'b01) begin
                clk_out_1 <= ~clk_out_1;
            end else if (count == 2'b10) begin
                clk_out_2 <= ~clk_out_2;
                count <= 2'b00;
            end
        end
    end

endmodule