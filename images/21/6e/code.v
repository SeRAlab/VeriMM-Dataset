module gradient_descent (
    input wire clk,
    input wire reset,
    input wire [31:0] current_value,
    input wire [31:0] learning_rate,
    output reg [31:0] updated_value
);
    parameter GRADIENT = 32'd5; // Simulated gradient

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            updated_value <= 32'd0;
        end else begin
            updated_value <= current_value - (learning_rate * GRADIENT);
        end
    end
endmodule