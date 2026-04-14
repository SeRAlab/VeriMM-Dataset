module gray_code_counter_2bit (
    input clk,
    input rst,
    output reg [1:0] gray
);

reg [1:0] binary;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        binary <= 2'b00;
    end else begin
        binary <= binary + 1;
    end
end

always @(binary) begin
    gray = binary ^ (binary >> 1);
end

endmodule