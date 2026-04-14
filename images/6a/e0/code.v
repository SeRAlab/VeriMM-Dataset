module top_module(
    input [3:0] A,
    input [3:0] B,
    output reg [4:0] X  // Change output type to reg
);wire [4:0] sum;

    assign sum = A + B;

    always @(*) begin
        if (sum <= 15) begin
            X = {1'b0, sum};
        end else begin
            X = sum;
        end
    end

endmodule