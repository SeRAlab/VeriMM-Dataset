module top_module(
    input clk,
    input rst,
    input en,
    input test_input,
    output reg test_output,
    output reg [3:0] count_out
);always @(posedge clk, posedge rst) begin
    if (rst) begin
        count_out <= 4'b0;
        test_output <= 1'b0;
    end else if (en) begin
        if (test_input) begin
            if (count_out == 4'hF) begin
                count_out <= 4'b0;
                test_output <= 1'b1;
            end else begin
                count_out <= count_out + 1;
                test_output <= 1'b0;
            end
        end else begin
            count_out <= count_out + 1;
        end
    end
end

endmodule