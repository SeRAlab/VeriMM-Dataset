module gray_code_counter_2bit(
    input clk,
    input rst,

    output reg [1:0] gray_q
);

reg [1:0] binary_q;  // Internal binary counter

// Gray Code Counter logic
always @(posedge clk) begin
    if (rst)
        binary_q <= 2'b00;
    else
        binary_q <= binary_q + 1;
end

// Convert binary counter to Gray code
always @(binary_q) begin
    gray_q = binary_q ^ (binary_q >> 1);
end

endmodule