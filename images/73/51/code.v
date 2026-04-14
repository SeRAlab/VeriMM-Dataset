module top_module(
    input [2:0] a, b,
    input [1:0] select,
    output reg [2:0] comparison_result,
    output reg [1:0] input_selected
);always @* begin
        if (a > b) begin
            comparison_result = a;
            input_selected = 2'b00;
        end
        else if (b > a) begin
            comparison_result = b;
            input_selected = 2'b01;
        end
        else begin
            comparison_result = a;
            input_selected = select;
        end
    end

endmodule