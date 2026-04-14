module async_reset_register(
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
    );

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            q <= 8'b00000000;
        end else begin
            q <= d;
        end
    end
endmodule