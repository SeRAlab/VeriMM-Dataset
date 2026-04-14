module gray_counter(
    input       clk,
    input       rst,
    output reg [1:0] gray_count
);

    reg [1:0] binary_count;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            binary_count <= 2'b00;
        end
        else begin
            binary_count <= binary_count + 1;
        end
    end

    always @(binary_count) begin
        gray_count = binary_count ^ (binary_count >> 1);
    end

endmodule