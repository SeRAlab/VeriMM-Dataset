module top_module(
    input clk,
    input rst_n,
    input cin,
    input [7:0] A,
    input [7:0] B,
    output reg [8:0] sum,
    output reg cout
);reg [8:0] temp_sum;
reg [7:0] temp_carry;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum <= 0;
        cout <= 0;
        temp_sum <= 0;
        temp_carry <= 0;
    end else begin
        temp_sum <= A + B + cin;
        temp_carry <= {1'b0, temp_sum[8]};
        sum <= temp_sum;
        cout <= temp_carry[8];
    end
end

endmodule