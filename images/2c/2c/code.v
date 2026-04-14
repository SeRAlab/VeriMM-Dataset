module butterworth_filter (
    input wire clk,
    input wire rst,
    input wire x,     // Input signal
    output reg y     // Output signal
);
    reg [1:0] x_prev; // Previous inputs
    reg [1:0] y_prev; // Previous outputs

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x_prev <= 2'b00;
            y_prev <= 2'b00;
            y <= 0;
        end else begin
            // Butterworth filter logic (simple version)
            y <= (x + x_prev[0] + x_prev[1] - y_prev[0] - y_prev[1]) >> 1; // Simple averaging
            x_prev <= {x_prev[0], x}; // Shift previous inputs
            y_prev <= {y_prev[0], y}; // Shift previous outputs
        end
    end
endmodule