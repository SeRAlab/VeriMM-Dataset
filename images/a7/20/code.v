module binary_down_counter_3bit(
    input wire clk,
    input wire rst,
    input wire en,
    output reg [2:0] count
);

    always @(posedge clk) begin
        if (rst) begin
            count <= 3'b111;
        end else if (en) begin
            count <= count - 1;
        end
    end
endmodule