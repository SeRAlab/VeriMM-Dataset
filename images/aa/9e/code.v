module gray_counter (
    input wire clk,
    input wire rstn,
    output reg [1:0] count
);

always @(posedge clk)
begin
    if (~rstn)
        count <= 2'b00;
    else
        case (count)
            2'b00: count <= 2'b01;
            2'b01: count <= 2'b11;
            2'b11: count <= 2'b10;
            2'b10: count <= 2'b00;
            default: count <= 2'b00;
        endcase
end

endmodule