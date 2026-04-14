module gray_code_counter(
    input clk,
    input rst,
    output reg [3:0] q
);

reg [3:0] binary_counter;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        binary_counter <= 4'd0;
        q <= 4'd0;
    end else begin
        binary_counter <= binary_counter + 1;
        q <= (binary_counter >> 1) ^ binary_counter;
    end
end

endmodule