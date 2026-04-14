module adaptive_lms_filter #(
    parameter N = 5,           // Number of coefficients
    parameter DATA_WIDTH = 16  // Bit-width of data
)(
    input clk,
    input rst,
    input signed [DATA_WIDTH-1:0] x_in,  // Input signal
    input signed [DATA_WIDTH-1:0] d_in,  // Desired signal
    output signed [DATA_WIDTH-1:0] y_out  // Output signal
);
    reg signed [DATA_WIDTH-1:0] w [0:N-1]; // Coefficients
    reg signed [DATA_WIDTH-1:0] y;          // Output signal
    reg signed [DATA_WIDTH-1:0] e;          // Error signal
    reg signed [DATA_WIDTH-1:0] mu = 16'h0001; // Step size

    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= 0;
            end
            y <= 0;
        end else begin
            // Calculate the output
            y <= 0;
            for (i = 0; i < N; i = i + 1) begin
                y <= y + w[i] * x_in; // Output calculation
            end

            // Calculate error
            e <= d_in - y;

            // Update coefficients
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= w[i] + (mu * e * x_in); // LMS update rule
            end
        end
    end

    assign y_out = y;

endmodule