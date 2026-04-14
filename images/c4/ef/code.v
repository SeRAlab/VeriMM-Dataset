module check_1ns(
    input [31:0] time_values,
    output reg check
);

    // Extract timeunit and timeprecision values from input
    reg [15:0] timeunit = time_values[31:16];
    reg [15:0] timeprecision = time_values[15:0];

    // Check if timeunit and timeprecision are both 1ns
    always @* begin
        if (timeunit == 1 && timeprecision == 1) begin
            check = 1;
        end else begin
            check = 0;
        end
    end

endmodule