module gray_code_counter(
    input               clk,
    input               rst,
    
    output reg [1:0]    gray_code
);

always@(posedge clk or posedge rst) begin
    if (rst)
        gray_code <= 2'b00;
    else begin
        case (gray_code)
            2'b00: gray_code <= 2'b01;
            2'b01: gray_code <= 2'b11;
            2'b11: gray_code <= 2'b10;
            2'b10: gray_code <= 2'b00;
            default: gray_code <= 2'b00;
        endcase
    end
end

endmodule