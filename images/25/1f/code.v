module current_sensor (
    input wire clk,
    input wire reset,
    input wire [9:0] current_value,
    output reg exceeds_threshold
    );

    parameter THRESHOLD = 10'd500; // Define a threshold for current

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            exceeds_threshold <= 1'b0;
        end else begin
            if (current_value > THRESHOLD) begin
                exceeds_threshold <= 1'b1;
            end else begin
                exceeds_threshold <= 1'b0;
            end
        end
    end
endmodule