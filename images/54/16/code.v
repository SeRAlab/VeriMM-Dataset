module binary_counter_5bit(
    input wire clk,
    input wire rst,
    output reg [4:0] count
);

    always @(posedge clk) begin
        if (rst) begin
            count <= 5'b00000;
        end else begin
            count <= count + 1;
        end
    end
endmodule