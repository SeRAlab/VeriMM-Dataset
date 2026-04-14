module binary_up_down_counter_6bit(
    input wire clk,
    input wire rst,
    input wire dir,
    output reg [5:0] count
);

    always @(posedge clk) begin
        if (rst) begin
            count <= 6'b000000;
        end else if (dir) begin
            count <= count + 1;
        end else begin
            count <= count - 1;
        end
    end
endmodule