module gray_code_counter(
    input       clk,
    input       rst,
    output reg [3:0] gray_count
);

    reg [3:0] binary_count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            binary_count <= 4'b0000;
        end
        else begin
            binary_count <= binary_count + 1'b1;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            gray_count <= 4'b0000;
        end
        else begin
            gray_count <= (binary_count >> 1) ^ binary_count;
        end
    end

endmodule