module counter_with_preset
(
    input clk,
    input reset,
    input preset,
    input [5:0] preset_value,
    output reg [5:0] count
);

    always @(posedge clk or posedge reset or posedge preset) begin
        if (reset) begin
            count <= 6'b000000; // Clear counter to 0
        end else if (preset) begin
            count <= preset_value; // Preset counter to given value
        end else begin
            count <= count + 1; // Increment counter
        end
    end

endmodule