module graycode_counter (
    input wire clk,
    input wire rst,
    output reg [2:0] gray_out
);

    reg [2:0] binary_count;

    always @(posedge clk or posedge rst) begin
        if (rst)
            binary_count <= 3'b000;
        else
            binary_count <= binary_count + 1;
    end

    always @(*) begin
        gray_out = binary_count ^ (binary_count >> 1);
    end

endmodule