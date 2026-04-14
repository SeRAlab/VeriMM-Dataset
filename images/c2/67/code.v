module up_down_counter (
    input clk,
    input async_reset,
    input [1:0] enable,
    output reg [1:0] count
);

    always @(posedge clk or negedge async_reset) begin
        if (!async_reset) begin
            count <= 2'b00;
        end else begin
            case (enable)
                2'b00: count <= count;
                2'b01: count <= count + 2'b01;
                2'b10: count <= count - 2'b01;
                default: count <= count;
            endcase
        end
    end

endmodule