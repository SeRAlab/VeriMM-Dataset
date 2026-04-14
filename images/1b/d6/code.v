module down_counter (
    input wire clk,
    input wire rst,
    input wire [3:0] preset_value,
    output reg [3:0] count
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= preset_value; // Load preset value on reset
        end else begin
            if (count == 4'b0000) begin
                count <= 4'b1111; // Wrap around when count reaches 0
            end else begin
                count <= count - 1; // Count down
            end
        end
    end
endmodule