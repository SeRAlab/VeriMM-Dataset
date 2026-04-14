module shift_register_8bit (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [7:0] parallel_in,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 8'b00000000;
        end else if (enable) begin
            q <= parallel_in;
        end else begin
            q <= {q[6:0], 1'b0};
        end
    end

endmodule