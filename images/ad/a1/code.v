module binary_counter_5bit_with_enable(
    input wire clk,
    input wire rst,
    input wire en,
    output reg [4:0] count
);

    always @(posedge clk) begin
        if (rst) begin
            count <= 5'b00000;
        end else if (en) begin
            count <= count + 1;
        end
    end
endmodule