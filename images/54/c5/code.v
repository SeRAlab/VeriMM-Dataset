module gray_code_counter_3bit(
    input clk,
    input rst_n,
    output reg [2:0] gray_code
);

reg [2:0] binary_counter;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        binary_counter <= 3'b000;
    end else begin
        binary_counter <= binary_counter + 1;
    end
end

always @(*) begin
    gray_code = binary_counter ^ (binary_counter >> 1);
end

endmodule