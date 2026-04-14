module shift_left_module(
    input wire clk,
    input wire reset,
    input wire [7:0] binary_num,
    output reg [7:0] shifted_num
);

    always @(posedge clk) begin
        if (reset) begin
            shifted_num <= 0;
        end else begin
            shifted_num <= binary_num << 1;
        end
    end

endmodule