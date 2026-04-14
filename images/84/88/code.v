module top_module(
    input clk,
    input reset,
    input [7:0] in_a,
    input [7:0] in_b,
    input select,
    output reg [7:0] out
);reg [7:0] a_shifted;
reg [7:0] b_shifted;
reg [7:0] result;

always @(posedge clk, negedge reset) begin
    if (reset == 0) begin
        a_shifted <= 8'b0;
        b_shifted <= 8'b0;
        result <= 8'b0;
    end else begin
        a_shifted <= {in_a[7], in_a[6], in_a[5], in_a[4], in_a[3], in_a[2], in_a[1], in_a[0]};
        b_shifted <= {in_b[7], in_b[6], in_b[5], in_b[4], in_b[3], in_b[2], in_b[1], in_b[0]};
        if (select == 1) begin
            result <= a_shifted + b_shifted;
        end else begin
            result <= a_shifted - b_shifted;
        end
    end
end

always @(posedge clk, negedge reset) begin
    if (reset == 0) begin
        out <= 8'b0;
    end else begin
        out <= {result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7]};
    end
end

endmodule