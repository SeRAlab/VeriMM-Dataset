module gray_code_counter(
    input  clk,
    input  rst,
    output reg [2:0] gray_code
);

reg [2:0] binary_counter;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        binary_counter <= 3'b000;
        gray_code <= 3'b000;
    end else begin
        binary_counter <= binary_counter + 1;
        gray_code <= binary_counter ^ (binary_counter >> 1);
    end
end

endmodule