module top_module(
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] C  // Change output to reg to assign in always block
);wire [4:0] sum;

    assign sum = A + B;

    always @(*) begin
        if (sum > 9) begin
            C = sum - 6;
        end else begin
            C = sum[3:0];  // Assigning only the lower 4 bits
        end
    end

endmodule