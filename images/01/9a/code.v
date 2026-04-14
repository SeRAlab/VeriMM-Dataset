module current_sensor (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [15:0] step_value,
    output reg [15:0] current_level
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_level <= 16'b0;
        end else if (enable) begin
            if (current_level + step_value > 16'hFFFF) begin
                current_level <= 16'b0; // Reset to zero if exceeding max
            end else begin
                current_level <= current_level + step_value;
            end
        end
    end
endmodule