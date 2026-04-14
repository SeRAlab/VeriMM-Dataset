module down_counter_6bit(
    input wire clk,
    input wire rst,
    output reg [5:0] count
);

    always @(posedge clk) begin
        if (rst) begin
            count <= 6'b111111;
        end else begin
            count <= count - 1;
        end
    end
endmodule