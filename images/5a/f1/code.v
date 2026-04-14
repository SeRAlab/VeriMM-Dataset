module gray_counter (
  input clk,
  input rst,
  input en,
  output reg [1:0] gray);

always @(posedge clk or posedge rst) begin
    if (rst)
        gray <= 2'b00;
    else if (en) begin
        case (gray)
            2'b00: gray <= 2'b01;
            2'b01: gray <= 2'b11;
            2'b11: gray <= 2'b10;
            2'b10: gray <= 2'b00;
            default: gray <= 2'b00;
        endcase
    end
end
endmodule