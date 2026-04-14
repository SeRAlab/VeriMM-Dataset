module binary_counter_preset_7bit(
    input wire clk,
    input wire rst,
    input wire preset,
    input wire [6:0] preset_value,
    output reg [6:0] count
);

    always @(posedge clk) begin
        if (rst) begin
            count <= 7'b0000000;
        end else if (preset) begin
            count <= preset_value;
        end else begin
            count <= count + 1;
        end
    end
endmodule