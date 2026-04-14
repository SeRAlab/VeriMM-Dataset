module gray_code_counter (
        input clk,
        input reset,
        output reg [1:0] gray_count);always @(posedge clk) begin
    if (reset)
        gray_count <= 2'b00;
    else
        case (gray_count)
            2'b00: gray_count <= 2'b01;
            2'b01: gray_count <= 2'b11;
            2'b11: gray_count <= 2'b10;
            2'b10: gray_count <= 2'b00;
            default: gray_count <= 2'b00;
        endcase
end

endmodule