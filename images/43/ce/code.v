module top_module(
    input [3:0] A,
    input [3:0] B,
    input sub,
    output [3:0] sum,
    output reg overflow  // Change net to reg for overflow
);reg [4:0] temp_sum;

    always @(*) begin
        if (sub) begin
            temp_sum = A - B;
            if (temp_sum < 0) begin
                overflow = 1;
            end else begin
                overflow = 0;
            end
        end else begin
            temp_sum = A + B;
            if (temp_sum > 15) begin
                overflow = 1;
            end else begin
                overflow = 0;
            end
        end
    end

    assign sum = temp_sum[3:0];

endmodule