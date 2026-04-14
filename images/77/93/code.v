module binary_counter_8bit(
    input wire clk,
    input wire rst,
    input wire up_down,
    output reg [7:0] count
);

    always @(posedge clk) begin
        if (rst) begin
            count <= 8'b00000000;
        end else begin
            if (up_down) begin
                count <= count + 1;
            end else begin
                count <= count - 1;
            end
        end
    end
endmodule