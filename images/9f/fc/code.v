module register_with_async_reset_n (
    input clk,
    input reset_n,
    output reg [7:0] reg_out
);

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            reg_out <= 8'b00000000;
    end

endmodule