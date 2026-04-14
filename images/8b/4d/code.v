module gray_code_counter(
    input wire clk,
    input wire rst_n,
    output reg [1:0] gray_count
    );

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        gray_count <= 2'd0;
    else begin
        case (gray_count)
            2'b00: gray_count <= 2'b01;
            2'b01: gray_count <= 2'b11;
            2'b11: gray_count <= 2'b10;
            2'b10: gray_count <= 2'b00;
            default: gray_count <= 2'b00;
        endcase
    end
end

endmodule