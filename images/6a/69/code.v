module binary_counter_5bit(
    input wire clk,
    input wire rst,
    input wire en,
    output reg [4:0] count
    );

always @(posedge clk or posedge rst) begin
    if (rst)
        count <= 5'b00000;
    else if (en)
        count <= count + 1;
end

endmodule